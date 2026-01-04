import 'package:flutter/material.dart';
import 'package:meetwho/data/list_repository.dart' as repository;
import 'package:meetwho/model/profile.dart';
import 'package:meetwho/ui/list.dart' as list_page; // Aliased import
import 'package:meetwho/ui/detail.dart' as detailpage;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Profile> get _pastMeetings {
    final now = DateTime.now(); // The exact current time
    final List<Profile> past = [];

    for (final profile in repository.dummylistitem) {
      try {
        final meetingDateTime = DateTime.parse('${profile.date} ${profile.time}');
        // Check if the meeting time is before the exact current time.
        if (meetingDateTime.isBefore(now)) {
          past.add(profile);
        }
      } catch (e) {
        // Ignore profiles with invalid date/time formats
      }
    }
    // Sort from newest to oldest
    past.sort((a, b) {
      final dateTimeA = DateTime.parse('${a.date} ${a.time}');
      final dateTimeB = DateTime.parse('${b.date} ${b.time}');
      return dateTimeB.compareTo(dateTimeA); // Newest first
    });
    return past;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No past meetings yet.',
        style: TextStyle(color: Colors.white70),
      ),
    );

    if (_pastMeetings.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: _pastMeetings.length,
        itemBuilder: (context, index) {
          final profile = _pastMeetings[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: list_page.MeetingCard( // Use aliased import
              profile: profile,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => detailpage.Detail(profile: profile),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const _HeaderWave(title: "Meeting History"),
          Expanded(child: content),
        ],
      ),
    );
  }
}

// Reusing the _HeaderWave from list.dart
class _HeaderWave extends StatelessWidget {
  const _HeaderWave({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    const r = 20.0;

    return Container(
      height: 125,
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF2E7AF6), Color(0xFF45ABF0), Color(0xFF4DD7FF)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const Text(
              "Review your past meetings",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(179, 29, 28, 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
