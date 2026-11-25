import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

import 'package:provider/provider.dart';

import '../models/experience.dart';
import '../services/api_client.dart';
import '../services/auth_state.dart';
import '../widgets/auth_guard.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final experience = Experience(
        title: _title.trim(),
        description: _description.trim(),
        category: _category,
        stage: _stage,
        thumbnail: _thumbnail.trim(),
        endedAt: _endedAt?.toUtc(),
      );
      final saved = await context.read<ApiClient>().createExperience(
        experience,
        context.read<AuthState>().token!,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Experience added successfully!'),
          content: Text(saved.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.invalidToken) {
        context.read<AuthState>().clear();
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save experience. Check your connection.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _title = "";
  String _description = "";
  String _category = "full-time";
  String _stage = "university";
  String _thumbnail = "";
  DateTime? _endedAt; // null means ongoing

  final Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
    'committee': 'Committee',
    'organization': 'Organization',
  };

  final Map<String, String> _stages = {
    'university': 'University',
    'high-school': 'High School',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Experience Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    hintText: "COMPFEST 18 | PIC of Decoration",
                    labelText: "Experience Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  validator: (String? value) {
                    final title =
                        value?.replaceAll(RegExp(r'<[^>]*>'), '').trim() ?? '';
                    if (title.isEmpty) {
                      return "Enter an experience title.";
                    }
                    if (value!.length > 255) {
                      return "The title must be at most 255 characters.";
                    }
                    return null;
                  },
                ),
              ),
              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _description,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Describe your role and contribution",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (String? value) {
                    final description =
                        value?.replaceAll(RegExp(r'<[^>]*>'), '').trim() ?? '';
                    if (description.isEmpty) {
                      return "Enter an experience description.";
                    }
                    return null;
                  },
                ),
              ),
              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),
              // === Education Stage ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Education Stage",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _stage,
                  items: _stages.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _stage = newValue!;
                    });
                  },
                ),
              ),
              // === Thumbnail URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _thumbnail,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://example.com/image.png",
                    labelText: "Thumbnail URL (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _thumbnail = value;
                    });
                  },
                  validator: (String? value) {
                    final url = value?.trim() ?? '';
                    if (url.isEmpty) return null;
                    final uri = Uri.tryParse(url);
                    if (url.length > 200) {
                      return "The URL must be at most 200 characters.";
                    }
                    if (uri == null ||
                        ![
                          'http',
                          'https',
                          'ftp',
                          'ftps',
                        ].contains(uri.scheme) ||
                        uri.host.isEmpty ||
                        RegExp(r'\s').hasMatch(url)) {
                      return "Enter a valid thumbnail URL.";
                    }
                    return null;
                  },
                ),
              ),
              // === End Date (optional; leave empty for ongoing experiences) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  initialValue: _endedAt,
                  builder: (field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: "End Date (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: field.value ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100, 12, 31),
                                );
                                if (date == null || !context.mounted) return;
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    field.value ?? DateTime.now(),
                                  ),
                                );
                                if (time == null || !context.mounted) return;
                                final endedAt = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                                setState(() {
                                  _endedAt = endedAt;
                                  field.didChange(endedAt);
                                });
                              },
                              child: Text(
                                field.value == null
                                    ? "Ongoing — select an end date and time"
                                    : field.value.toString().substring(0, 16),
                              ),
                            ),
                          ),
                          if (field.value != null)
                            IconButton(
                              tooltip: "Clear end date (ongoing)",
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _endedAt = null;
                                  field.didChange(null);
                                });
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // === Save Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _saving ? null : _submit,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
