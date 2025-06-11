// lib/models/event.dart
import 'package:flutter/material.dart'; // Für TimeOfDay und DateTime

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final int maxParticipants;
  final int organizerId; // ID des Benutzers, der das Event erstellt hat

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.maxParticipants,
    required this.organizerId,
  });

  // Factory-Methode, um ein Event-Objekt aus einer JSON-Map zu erstellen
  // Dies wird nützlich sein, wenn wir Daten vom Backend empfangen
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']), // Annahme: Datum als ISO 8601 String
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]), // Annahme: Zeit als "HH:MM" String
        minute: int.parse(json['time'].split(':')[1]),
      ),
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      organizerId: json['organizerId'],
    );
  }

  // Methode, um ein Event-Objekt in eine JSON-Map für das Backend zu konvertieren
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String().split('T').first, // Nur Datumsteil senden
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'location': location,
      'maxParticipants': maxParticipants,
      'organizerId': organizerId,
    };
  }
}