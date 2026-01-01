import 'package:flutter/material.dart';

enum MeetingCategory { personal, work, teammate, project, school, other }
enum MeetingStatus { scheduled, completed, cancelled }

class Meeting {
  final String meetingId;
  final String personName;
  final MeetingCategory category;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String notes;
  final MeetingStatus status;

  Meeting({
    required this.meetingId,
    required this.personName,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.notes,
    required this.status,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      meetingId: json['meetingId'],
      personName: json['personName'],
      category: MeetingCategory.values.firstWhere(
          (e) => e.toString().split('.').last == json['category']),
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
          hour: int.parse(json['time'].split(':')[0]),
          minute: int.parse(json['time'].split(':')[1])),
      location: json['location'],
      notes: json['notes'],
      status: MeetingStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meetingId': meetingId,
      'personName': personName,
      'category': category.toString().split('.').last,
      'date': date.toIso8601String().split('T')[0],
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'location': location,
      'notes': notes,
      'status': status.toString().split('.').last,
    };
  }
}
