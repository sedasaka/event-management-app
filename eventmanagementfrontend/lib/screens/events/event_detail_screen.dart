// lib/screens/events/event_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:eventmanagementfrontend/models/event.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isRegistering = false; // Für Ladezustand der Registrierung
  String? _registrationMessage; // Für Erfolgs-/Fehlermeldungen

  Future<void> _registerForEvent() async {
    setState(() {
      _isRegistering = true;
      _registrationMessage = null;
    });


    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulierte API-Verzögerung

      // Simulierte Erfolg oder Misserfolg basierend auf Logik
      if (widget.event.id == 1) { // Beispiel: Event 1 ist immer erfolgreich
        _registrationMessage = 'Successfully registered for ${widget.event.title}!';
      } else { // Andere Events simulieren einen Fehler
        throw Exception('Failed to register. Event might be full or already registered.');
      }
      
      // TODO: Actual API call:
      // final response = await http.post(
      //   Uri.parse('http://localhost:8080/api/events/${widget.event.id}/register'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'userId': dummyUserId}), // Backend erwartet userId im Body
      // );
      // if (response.statusCode == 200) {
      //   _registrationMessage = 'Successfully registered!';
      // } else {
      //   throw Exception('Failed to register: ${response.body}');
      // }

    } catch (error) {
      _registrationMessage = 'Error registering: ${error.toString()}';
    } finally {
      setState(() {
        _isRegistering = false;
      });
      // Zeige Snackbar mit Meldung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_registrationMessage!),
          backgroundColor: _registrationMessage!.contains('Error') ? Colors.red : Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.event.location} - ${widget.event.date.toLocal().toString().split(' ')[0]} at ${widget.event.time.format(context)}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.event.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Max Participants: ${widget.event.maxParticipants}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _isRegistering
                ? const Center(child: CircularProgressIndicator()) // Ladeindikator
                : ElevatedButton(
                    onPressed: _registerForEvent,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // Volle Breite
                    ),
                    child: const Text(
                      'Register for Event',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}