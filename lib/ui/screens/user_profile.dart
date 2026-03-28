import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetwho/data/repositories/list_repository.dart';
import 'package:meetwho/data/enums/category.dart';
import 'package:meetwho/models/user.dart';
import 'package:meetwho/data/repositories/user_repository.dart' as user_repo;
import 'package:meetwho/ui/widgets/category_pie_chart.dart';
import 'package:meetwho/ui/widgets/overview_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<void> _showLoginDialog() async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Your Name'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            autofocus: true,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Please enter a name'
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(nameController.text.trim());
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      setState(() {
        user_repo.currentUser = User(name: name);
      });
    }
  }

  void _logout() {
    setState(() {
      user_repo.currentUser = null;
    });
  }

  Category _mapStringToCategory(String interest) {
    switch (interest.trim().toLowerCase()) {
      case 'work': return Category.work;
      case 'project': return Category.project;
      case 'personal': return Category.personal;
      case 'team': return Category.team;
      case 'school': return Category.school;
      default: return Category.other;
    }
  }

  int _calculateHistoryCount(List repositoryItems) {
    final now = DateTime.now();
    int count = 0;
    for (final profile in repositoryItems) {
      try {
        final meetingDateTime = DateTime.parse('${profile.date} ${profile.time}');
        if (meetingDateTime.isBefore(now)) count++;
      } catch (_) {}
    }
    return count;
  }

  Map<Category, int> _calculateCategoryCounts(List repositoryItems) {
    final Map<Category, int> counts = {};
    for (final profile in repositoryItems) {
      if (profile.interests.isNotEmpty) {
        final category = _mapStringToCategory(profile.interests.first);
        counts.update(category, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final user = user_repo.currentUser;
    final repository = context.watch<ListRepository>();
    final items = repository.profiles;
    
    final historyCount = _calculateHistoryCount(items);
    final categoryCounts = _calculateCategoryCounts(items);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                      child: Text(
                        user?.initials ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user?.name ?? 'Please log in',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: user == null ? _showLoginDialog : _logout,
                      child: Text(user == null ? 'Login' : 'Logout'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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
                    value: items.length.toString(),
                    label: "Meeting",
                  ),
                  const SizedBox(width: 12),
                  OverviewCard(
                    value: historyCount.toString(),
                    label: "History",
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
                  categoryCounts: categoryCounts,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
