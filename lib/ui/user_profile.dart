import 'package:flutter/material.dart';
import 'package:meetwho/data/list_repository.dart' as repository;

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  int get _historyCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int count = 0;
    for (final profile in repository.dummylistitem) {
      try {
        final meetingDate = DateTime.parse(profile.date);
        if (meetingDate.isBefore(today)) {
          count++;
        }
      } catch (e) {
        // Ignore profiles with invalid date format
      }
    }
    return count;
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

              // ===== PROFILE =====
              // [For Future Dev]
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ===== MEETING OVERVIEW =====
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
                  _OverviewCard(
                      value: repository.dummylistitem.length.toString(),
                      label: "Meeting"),
                  const SizedBox(width: 12),
                  _OverviewCard(value: _historyCount.toString(), label: "History"),
                ],
              ),

              const SizedBox(height: 30),

              // ===== CHART =====
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
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                     Color.fromARGB(255, 80, 148, 235),
                     Color(0xFF4DBBFF),
                   ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),

                    // Chart [Probably changing]
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 50),

                    // CategoryItem
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _CategoryItem(text: "Personal   1"),
                        _CategoryItem(text: "Work       1"),
                        _CategoryItem(text: "Teammate   1"),
                        _CategoryItem(text: "Project    1"),
                        _CategoryItem(text: "School     1"),
                        _CategoryItem(text: "Other      1"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== SMALL UI COMPONENTS =====

class _OverviewCard extends StatelessWidget {
  final String value;
  final String label;

  const _OverviewCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 91, 162, 255),
              Color(0xFF4DBBFF),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String text;

  const _CategoryItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
