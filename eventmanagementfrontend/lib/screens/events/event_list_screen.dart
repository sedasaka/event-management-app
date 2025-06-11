// lib/screens/events/event_list_screen.dart
import 'package:flutter/material.dart';
import 'package:eventmanagementfrontend/models/event.dart'; // Event-Modell importieren
import 'package:eventmanagementfrontend/screens/events/event_detail_screen.dart';
import 'package:eventmanagementfrontend/screens/events/create_event_screen.dart'; // Für den FloatingActionButton
import 'package:eventmanagementfrontend/screens/profile/profile_screen.dart'; // Für den Profil-Button

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  // Dummydaten für Events (später durch API-Calls ersetzt)
  List<Event> _events = [
    Event(
      id: 1,
      title: 'Tech Summit 2025',
      description: 'The biggest tech conference of the year!',
      date: DateTime.now().add(const Duration(days: 10)),
      time: const TimeOfDay(hour: 9, minute: 0),
      location: 'Congress Center, Berlin',
      maxParticipants: 500,
      organizerId: 101,
    ),
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
    Event(
      id: 3,
      title: 'Web Dev Workshop',
      description: 'Hands-on workshop for modern web development.',
      date: DateTime.now().add(const Duration(days: 30)),
      time: const TimeOfDay(hour: 10, minute: 0),
      location: 'Online (Zoom)',
      maxParticipants: 100,
      organizerId: 101,
    ),
  ];
  bool _isLoading = false; // Für Ladeindikatoren

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true; // Ladezustand anzeigen
    });
    // Hier würde später der API-Call zum Backend erfolgen
    // Für jetzt simulieren wir eine Verzögerung
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Annahme: Aktualisierte Events vom Backend
      _events = [
        Event(
          id: 1,
          title: 'Tech Summit 2025 (Updated)',
          description: 'The biggest tech conference of the year!',
          date: DateTime.now().add(const Duration(days: 10)),
          time: const TimeOfDay(hour: 9, minute: 0),
          location: 'Congress Center, Berlin',
          maxParticipants: 500,
          organizerId: 101,
        ),
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
        Event(
          id: 4, // Neues Event
          title: 'AI Conference',
          description: 'Exploring the future of Artificial Intelligence.',
          date: DateTime.now().add(const Duration(days: 40)),
          time: const TimeOfDay(hour: 9, minute: 30),
          location: 'Munich Exhibition Center',
          maxParticipants: 300,
          organizerId: 103,
        ),
      ];
      _isLoading = false; // Ladezustand beenden
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Events beim Start laden
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Ladeindikator
          : RefreshIndicator(
              onRefresh: _fetchEvents, // Pull-to-Refresh
              child: _events.isEmpty
                  ? const Center(
                      child: Text('No events available. Create one!'),
                    )
                  : ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (ctx, i) {
                        final event = _events[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                          elevation: 5,
                          child: ListTile(
                            leading: const Icon(Icons.event),
                            title: Text(event.title),
                            subtitle: Text(
                              '${event.location} - ${event.date.toLocal().toString().split(' ')[0]}',
                            ),
                            trailing: Text('${event.maxParticipants} max'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => EventDetailScreen(event: event),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}