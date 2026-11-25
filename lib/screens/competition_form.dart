import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class CompetitionFormPage extends StatefulWidget {
  const CompetitionFormPage({super.key});

  @override
  State<CompetitionFormPage> createState() => _CompetitionFormPageState();
}

class _CompetitionFormPageState extends State<CompetitionFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _organizer = '';
  String? _competitionType; // Required. Starts unselected.
  String _description = '';
  DateTime? _competitionDate; // Required. Starts empty until a date is picked.
  String _achievement = '';
  String _participationType = 'individual'; // Django default.
  String _projectUrl = ''; // Optional.
  String _projectImageUrl = ''; // Optional.

  static const Map<String, String> _competitionTypes = {
    'hackathon': 'Hackathon',
    'data competition': 'Data Competition',
    'ui/ux': 'UI/UX',
  };

  static const Map<String, String> _participationTypes = {
    'individual': 'Individual',
    'group': 'Group',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Competition Form')),
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
              // === Competition Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    hintText: "Competition Name",
                    labelText: "Competition Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    _title = value;
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a competition name.";
                    }
                    if (value.trim().length > 255) {
                      return "Competition name must be at most 255 characters.";
                    }
                    return null;
                  },
                ),
              ),
              // === Organizer ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _organizer,
                  decoration: InputDecoration(
                    hintText: "Enter organizer name",
                    labelText: "Organizer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _organizer = value;
                    });
                  },
                  validator: (String? value) {
                    final input = value?.trim() ?? '';
                    if (input
                        .replaceAll(RegExp(r'<[^>]*>'), '')
                        .trim()
                        .isEmpty) {
                      return "Enter an organizer.";
                    }
                    if (input.length > 255) {
                      return "Organizer must be at most 255 characters.";
                    }
                    return null;
                  },
                ),
              ),
              // === Competition Type ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Competition Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _competitionType,
                  items: _competitionTypes.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _competitionType = newValue!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null ||
                        !_competitionTypes.containsKey(value)) {
                      return "Select a competition type.";
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
                    hintText: "Describe your contribution",
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
                    final input = value?.trim() ?? '';
                    if (input
                        .replaceAll(RegExp(r'<[^>]*>'), '')
                        .trim()
                        .isEmpty) {
                      return "Enter a description.";
                    }
                    return null;
                  },
                ),
              ),
              // === Competition Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  initialValue: _competitionDate,
                  validator: (DateTime? value) {
                    if (value == null) {
                      return "Select a competition date.";
                    }
                    return null;
                  },
                  builder: (field) {
                    return InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: field.value ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100, 12, 31),
                        );
                        if (date == null || !mounted) return;
                        setState(() {
                          _competitionDate = date;
                          field.didChange(date);
                        });
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Competition Date",
                          errorText: field.errorText,
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          field.value == null
                              ? "Select a competition date"
                              : field.value.toString().substring(0, 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // === Achievement ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _achievement,
                  decoration: InputDecoration(
                    hintText: "Participant, Finalist, 1st Place",
                    labelText: "Achievement",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _achievement = value;
                    });
                  },
                  validator: (String? value) {
                    final input = value?.trim() ?? '';
                    if (input
                        .replaceAll(RegExp(r'<[^>]*>'), '')
                        .trim()
                        .isEmpty) {
                      return "Enter an achievement.";
                    }
                    if (input.length > 255) {
                      return "Achievement must be at most 255 characters.";
                    }
                    return null;
                  },
                ),
              ),
              // === Participation Type ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Participation Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _participationType,
                  items: _participationTypes.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _participationType = newValue!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null ||
                        !_participationTypes.containsKey(value)) {
                      return "Select a participation type.";
                    }
                    return null;
                  },
                ),
              ),
              // === Competition URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _projectUrl,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://example.com/project",
                    labelText: "Competition URL (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _projectUrl = value;
                    });
                  },
                  validator: (String? value) {
                    final input = value?.trim() ?? '';
                    if (input.isEmpty) return null;
                    if (input.length > 200) {
                      return "Competition URL must be at most 200 characters.";
                    }
                    final uri = Uri.tryParse(input);
                    if (uri == null ||
                        ![
                          'http',
                          'https',
                          'ftp',
                          'ftps',
                        ].contains(uri.scheme) ||
                        uri.host.isEmpty ||
                        RegExp(r'\s').hasMatch(input)) {
                      return "Enter a valid URL.";
                    }
                    return null;
                  },
                ),
              ),
              // === Competition Image URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _projectImageUrl,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://example.com/image.png",
                    labelText: "Competition Image URL (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _projectImageUrl = value;
                    });
                  },
                  validator: (String? value) {
                    final input = value?.trim() ?? '';
                    if (input.isEmpty) return null;
                    if (input.length > 500) {
                      return "Competition Image URL must be at most 500 characters.";
                    }
                    final uri = Uri.tryParse(input);
                    if (uri == null ||
                        ![
                          'http',
                          'https',
                          'ftp',
                          'ftps',
                        ].contains(uri.scheme) ||
                        uri.host.isEmpty ||
                        RegExp(r'\s').hasMatch(input)) {
                      return "Enter a valid URL.";
                    }
                    return null;
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
                                'Competition added successfully!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Competition Title: $_title'),
                                    Text('Organizer: $_organizer'),
                                    Text(
                                      'Competition Type: ${_competitionTypes[_competitionType]}',
                                    ),
                                    Text('Description: $_description'),
                                    Text(
                                      'Competition Date: ${_competitionDate.toString().substring(0, 10)}',
                                    ),
                                    Text('Achievement: $_achievement'),
                                    Text(
                                      'Participation Type: ${_participationTypes[_participationType]}',
                                    ),
                                    Text(
                                      'Competition URL: ${_projectUrl.trim().isEmpty ? "Not provided" : _projectUrl}',
                                    ),
                                    Text(
                                      'Competition Image URL: ${_projectImageUrl.trim().isEmpty ? "Not provided" : _projectImageUrl}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _title = '';
                                      _organizer = '';
                                      _competitionType = null;
                                      _description = '';
                                      _competitionDate = null;
                                      _achievement = '';
                                      _participationType = 'individual';
                                      _projectUrl = '';
                                      _projectImageUrl = '';
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
