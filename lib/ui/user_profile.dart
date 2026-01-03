import 'package:flutter/material.dart';
import 'package:meetwho/data/list_repository.dart' as repository;
import 'package:meetwho/data/enums/category.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:meetwho/ui/widgets/category_pie_chart.dart';
import 'package:meetwho/ui/widgets/overview_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Helper to convert the string 'purpose' from Profile to a Category enum
  Category _mapStringToCategory(String interest) {
    switch (interest.trim().toLowerCase()) {
      case 'work':
        return Category.work;
      case 'project':
        return Category.project;
      case 'personal':
        return Category.personal;
      case 'team':
        return Category.team;
      case 'school':
        return Category.school;
      default:
        return Category.other;
    }
  }

  // Calculate the number of past meetings. [History]
  int get _historyCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int count = 0;

    for (final profile in repository.dummylistitem) {
      try {
        // Profile stores date as 'YYYY-MM-DD' and time as 'HH:mm'
        final meetingDateTime = DateTime.parse('${profile.date} ${profile.time}');
        if (meetingDateTime.isBefore(today)) {
          count++;
        }
      } catch (e) {
        // Ignore if date/time parsing fails
      }
    }
    return count;
  }

  // Calculate the number of meetings for each category. [Overview]
  Map<Category, int> get _categoryCounts {
    final Map<Category, int> counts = {};
    for (final profile in repository.dummylistitem) {
      if (profile.interests.isNotEmpty) {
        final category = _mapStringToCategory(profile.interests.first);
        counts.update(
          category,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('user-profile-screen-visibility-detector'),
      onVisibilityChanged: (visibilityInfo) {
        // If screen becomes fully visible, trigger a rebuild to get latest data.
        if (visibilityInfo.visibleFraction == 1) {
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Display the user's profile information.
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withOpacity(0.4),
                        child: const Text(
                          "N",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "More Custom! Press Login Button!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Display a summary of the meetings.
                const Text(
                  "Meeting Overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    OverviewCard(
                      value: repository.dummylistitem.length.toString(),
                      label: "Meeting",
                    ),
                    const SizedBox(width: 12),
                    OverviewCard(
                      value: _historyCount.toString(),
                      label: "History",
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Chart Card Text
                const Text(
                  "Chart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  height: 230,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 80, 148, 235),
                        Color(0xFF4DBBFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CategoryPieChart(
                    categoryCounts: _categoryCounts,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
