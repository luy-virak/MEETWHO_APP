import 'package:flutter/material.dart';
import 'package:meetwho/ui/form.dart' as formpage;
import 'package:meetwho/model/profile.dart';
import 'package:meetwho/data/list_repository.dart' as repository;

class List extends StatefulWidget {
  const List({super.key});

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {

  void onCreate() async
  {
    // Navigate to form page
    Profile ? newProfile = await Navigator.push<Profile>(
      context,
      MaterialPageRoute(builder: (context) => const formpage.FormPage()),
    );
    if(newProfile != null) {
      // If a new profile was created, add it to the list
      setState(() {
        repository.dummylistprofile.add(newProfile);
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    Widget content = const Center(child: Text('No Meetings added yet.'));

    if (repository.dummylistprofile.isNotEmpty) {
      content = ListView.builder(
        itemCount: repository.dummylistprofile.length,
        itemBuilder: (context, index) {
          final profile = repository.dummylistprofile[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(profile.name),
              subtitle: Text('Time: ${profile.time} mins\nDate: ${profile.date}\nInterests: ${profile.interests.join(', ')}'),
            ),
          );
        },
      );
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderWave(),

          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Today-Meetings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Upcoming-Meetings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),

          // ✅ SHOW YOUR LIST HERE
          Expanded(
            child: content,
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85),
        child: FloatingActionButton(
          onPressed: onCreate,
          backgroundColor: const Color.fromARGB(255, 49, 132, 237),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _HeaderWave extends StatelessWidget {
  const _HeaderWave();

  @override
  Widget build(BuildContext context) {
    const r = 20.0;

    return Container(
      height: 125,
      width: double.infinity,      // fill full width
      margin: EdgeInsets.zero,     // no gap on sides// important so shadow has space
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
          colors: [
            Color(0xFF2E7AF6),
            Color(0xFF45ABF0),
            Color(0xFF4DD7FF),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50),
            Text(
              "MeetWho",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              "Who are you meeting today?",
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
