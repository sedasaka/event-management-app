// lib/screens/events/create_event_screen.dart
import 'package:flutter/material.dart';
import 'package:eventmanagementfrontend/models/event.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>(); // Für Formular-Validierung
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false; // Für Ladezustand beim Speichern

  // Datumsauswahl
  Future<void> _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Zeitauswahl
  Future<void> _presentTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate(); // Formular validieren
    if (!isValid || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar( // Fehlermeldung
        const SnackBar(
          content: Text('Please fill all required fields and select date/time.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Hier würde später der API-Call zum Backend für das Erstellen des Events erfolgen
    // Annahme: organizerId kommt vom eingeloggten User
    final int dummyOrganizerId = 101;

    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch, // Dummy ID
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate!,
      time: _selectedTime!,
      location: _locationController.text,
      maxParticipants: int.parse(_maxParticipantsController.text),
      organizerId: dummyOrganizerId,
    );

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulierte API-Verzögerung

      print('New Event Created: ${newEvent.toJson()}');
      // TODO: Actual API call:
      // final response = await http.post(
      //   Uri.parse('http://localhost:8080/api/events'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(newEvent.toJson()),
      // );
      // if (response.statusCode == 201) {
      //   Navigator.of(context).pop(); // Zurück zur Event-Liste bei Erfolg
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Event created successfully!')),
      //   );
      // } else {
      //   throw Exception('Failed to create event: ${response.body}');
      // }

      Navigator.of(context).pop(); // Zurück zur Event-Liste bei Erfolg
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating event: ${error.toString()}'), // Fehlermeldung
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator()) // Ladeindikator
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Event Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 5) {
                          return 'Please enter at least 5 characters.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 10) {
                          return 'Please enter at least 10 characters.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a location.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _maxParticipantsController,
                      decoration: const InputDecoration(labelText: 'Max Participants'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Please enter a valid positive number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No Date Chosen!'
                                : 'Picked Date: ${(_selectedDate!).toLocal().toString().split(' ')[0]}',
                          ),
                        ),
                        TextButton(
                          onPressed: _presentDatePicker,
                          child: const Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedTime == null
                                ? 'No Time Chosen!'
                                : 'Picked Time: ${_selectedTime!.format(context)}',
                          ),
                        ),
                        TextButton(
                          onPressed: _presentTimePicker,
                          child: const Text('Choose Time', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Create Event'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}