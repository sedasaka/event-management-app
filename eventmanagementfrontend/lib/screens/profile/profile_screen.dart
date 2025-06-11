// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:eventmanagementfrontend/models/event.dart';
import 'package:eventmanagementfrontend/models/event_registration.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  // Dummydaten für eigene Events und Registrierungen
  List<Event> _myCreatedEvents = [
    Event(
      id: 1,
      title: 'My Awesome Workshop',
      description: 'A workshop organized by me!',
      date: DateTime.now().add(const Duration(days: 5)),
      time: const TimeOfDay(hour: 14, minute: 0),
      location: 'Online',
      maxParticipants: 20,
      organizerId: 101,
    ),
  ];

  List<EventRegistration> _myRegistrations = [
    EventRegistration(
      id: 101,
      userId: 1,
      eventId: 2,
      registrationDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
  // Annahme: Die Events, für die man sich angemeldet hat, müssen gematcht werden
  // Dies wäre in einer echten App komplexer (z.B. API-Call für registrierte Events)
  List<Event> _registeredEventsDetails = [
     Event(
      id: 2,
      title: 'Flutter Meetup Leipzig',
      description: 'Monthly gathering for Flutter enthusiasts.',
      date: DateTime.now().add(const Duration(days: 20)),
      time: const TimeOfDay(hour: 18, minute: 30),
      location: 'Spinnerei, Leipzig',
      maxParticipants: 50,
      organizerId: 102,
    ),
  ];

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
    });
    // Hier würden API-Calls zum Backend erfolgen, z.B.
    // - Benutzerdetails abrufen
    // - Eigene erstellte Events abrufen (`/api/users/{userId}/events` - falls vorhanden)
    // - Eigene Registrierungen abrufen (`/api/users/{userId}/registrations`)

    await Future.delayed(const Duration(seconds: 2)); // Simulierte Ladezeit

    setState(() {
      _isLoading = false;
      // Hier würden die Daten von den API-Calls zugewiesen werden
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Ladeindikator
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Benutzer-Informationen
                  const Text(
                    'User Information',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Username: exampleUser', style: TextStyle(fontSize: 16)),
                  const Text('Email: user@example.com', style: TextStyle(fontSize: 16)),
                  const Text('Role: PARTICIPANT', style: TextStyle(fontSize: 16)), // Dummy Role
                  const Divider(height: 30, thickness: 1),

                  // Eigene erstellte Events (wenn der Benutzer ein Organisator ist)
                  const Text(
                    'My Created Events',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _myCreatedEvents.isEmpty
                      ? const Text('No events created yet.')
                      : ListView.builder(
                          shrinkWrap: true, // Wichtig in Column
                          physics: const NeverScrollableScrollPhysics(), // Scrollen durch SingleChildScrollView
                          itemCount: _myCreatedEvents.length,
                          itemBuilder: (ctx, i) {
                            final event = _myCreatedEvents[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(event.title),
                                subtitle: Text(event.location),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // TODO: Navigation zum Edit-Screen für Events
                                    print('Edit event: ${event.title}');
                                  },
                                ),
                                onTap: () {
                                  // Navigiere zum Event-Detail-Screen
                                },
                              ),
                            );
                          },
                        ),
                  const Divider(height: 30, thickness: 1),

                  // Eigene Event-Anmeldungen
                  const Text(
                    'My Event Registrations',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _myRegistrations.isEmpty
                      ? const Text('No event registrations yet.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _myRegistrations.length,
                          itemBuilder: (ctx, i) {
                            final registration = _myRegistrations[i];
                            final registeredEvent = _registeredEventsDetails
                                .firstWhere((event) => event.id == registration.eventId);
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(registeredEvent.title),
                                subtitle: Text('Registered on: ${registration.registrationDate.toLocal().toString().split(' ')[0]}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    // TODO: Logik zum Abmelden vom Event
                                    print('Cancel registration for: ${registeredEvent.title}');
                                  },
                                ),
                                onTap: () {
                                  // Navigiere zum Event-Detail-Screen
                                },
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}