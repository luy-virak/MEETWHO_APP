import '../data/enums/category.dart';
import '../data/enums/meeting_status.dart';

class Meeting {
  final String meetingId;
  final String personName;
  final Category category;
  final DateTime dateTime;
  final String location;
  final String notes;
  MeetingStatus status;

  Meeting({
    required this.meetingId,
    required this.personName,
    required this.category,
    required this.dateTime,
    required this.location,
    required this.notes,
    required this.status,
  });

  // ================= JSON → MODEL =================
  factory Meeting.fromJson(Map<String, dynamic> json) {
    final String date = json['date']; // yyyy-MM-dd
    final String time = json['time']; // HH:mm

    return Meeting(
      meetingId: json['meetingId'],
      personName: json['personName'],
      category: Category.values.firstWhere(
        (c) => c.name.toLowerCase() == json['category'].toLowerCase(),
      ),
      dateTime: DateTime.parse('$date $time'),
      location: json['location'],
      notes: json['notes'],
      status: MeetingStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == json['status'].toLowerCase(),
      ),
    );
  }

  // ================= MODEL → JSON =================
  Map<String, dynamic> toJson() {
    final String date =
        '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}';

    final String time =
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';

    return {
      'meetingId': meetingId,
      'personName': personName,
      'category': category.name,
      'date': date,
      'time': time,
      'location': location,
      'notes': notes,
      'status': status.name,
    };
  }

  // ================= HELPERS =================

  bool get isCompleted => status == MeetingStatus.COMPLETED;

  bool get isToday {
    final now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }
}
