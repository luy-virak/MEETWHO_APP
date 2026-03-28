import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetwho/data/repositories/list_repository.dart';
import 'package:meetwho/models/profile.dart';
import 'package:meetwho/ui/screens/list.dart' as list_page;
import 'package:meetwho/ui/screens/detail.dart' as detailpage;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, List<Profile>> _getGroupedPastMeetings(List<Profile> items) {
    final Map<String, List<Profile>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final pastMeetings = items.where((p) {
      try {
        final meetingDateTime = DateTime.parse('${p.date} ${p.time}');
        return meetingDateTime.isBefore(now);
      } catch (e) {
        return false;
      }
    }).toList();

    pastMeetings.sort((a, b) {
      final dateTimeA = DateTime.parse('${a.date} ${a.time}');
      final dateTimeB = DateTime.parse('${b.date} ${b.time}');
      return dateTimeB.compareTo(dateTimeA);
    });

    for (final profile in pastMeetings) {
      final meetingDate = DateTime.parse(profile.date);
      final meetingDay = DateTime(meetingDate.year, meetingDate.month, meetingDate.day);

      String key;
      if (meetingDay == today) {
        key = 'Today';
      } else if (meetingDay == yesterday) {
        key = 'Yesterday';
      } else {
        key = profile.date;
      }

      if (grouped[key] == null) grouped[key] = [];
      grouped[key]!.add(profile);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<ListRepository>();
    final items = repository.profiles;
    final groupedMeetings = _getGroupedPastMeetings(items);
    
    final List<dynamic> displayItems = [];
    groupedMeetings.forEach((key, profiles) {
      displayItems.add(key);
      displayItems.addAll(profiles);
    });

    Widget content = const Center(
      child: Text(
        'No past meetings yet.',
        style: TextStyle(color: Colors.white70),
      ),
    );

    if (displayItems.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final item = displayItems[index];

          if (item is String) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          } else if (item is Profile) {
            final profile = item;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Dismissible(
                key: ValueKey('${profile.name}-${profile.date}-${profile.time}'),
                direction: DismissDirection.endToStart,
                background: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Meeting'),
                          content: const Text(
                            'Are you sure you want to delete this meeting from history?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (direction) {
                  // Note: Finding the index in the original list for removal
                  final idx = items.indexOf(profile);
                  if (idx != -1) repository.removeProfileAt(idx);
                },
                child: list_page.MeetingCard(
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
              ),
            );
          }
          return const SizedBox.shrink();
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

class _HeaderWave extends StatelessWidget {
  const _HeaderWave({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    const r = 20.0;
    return Container(
      height: 125,
      width: double.infinity,
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
