import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Experience added successfully!',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _title = "";
                                      _description = "";
                                      _category = "full-time";
                                      _stage = "university";
                                      _thumbnail = "";
                                      _endedAt = null;
                                    });
                                    // Rebuild the default initial values before resetting.
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          if (mounted) {
                                            _formKey.currentState!.reset();
                                          }
                                        });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
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
