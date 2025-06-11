// lib/models/event_registration.dart
class EventRegistration {
  final int id;
  final int userId; // ID des registrierten Benutzers
  final int eventId; // ID des Events
  final DateTime registrationDate;

  EventRegistration({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.registrationDate,
  });

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: json['id'],
      userId: json['userId'],
      eventId: json['eventId'],
      registrationDate: DateTime.parse(json['registrationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }
}