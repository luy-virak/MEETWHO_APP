import 'package:flutter/material.dart';
import 'package:meetwho/data/list_repository.dart' as repository;
import 'package:meetwho/data/enums/category.dart';

import 'package:meetwho/ui/widgets/category_pie_chart.dart';
import 'package:meetwho/ui/widgets/overview_card.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  // Calculate the number of past meetings.
  int get _historyCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int count = 0;

    for (final meeting in repository.dummylistitem) {
      if (meeting.dateTime.isBefore(today)) {
        count++;
      }
    }
    return count;
  }

  // Calculate the number of meetings for each category.
  Map<Category, int> get _categoryCounts {
    final Map<Category, int> counts = {};
    for (final meeting in repository.dummylistitem) {
      counts.update(
        meeting.category,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              // ===== BAR CHART =====
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
    );
  }
}
