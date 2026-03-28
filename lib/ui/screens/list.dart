import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetwho/ui/screens/form.dart' as formpage;
import 'package:meetwho/models/profile.dart';
import 'package:meetwho/data/repositories/list_repository.dart';
import 'package:meetwho/ui/screens/edit.dart' as editpage;
import 'package:meetwho/ui/screens/detail.dart' as detailpage;

class List extends StatefulWidget {
  const List({super.key});

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  void onCreate() async {
    Profile? newProfile = await Navigator.push<Profile>(
      context,
      MaterialPageRoute(builder: (context) => const formpage.FormPage()),
    );

    if (newProfile != null && mounted) {
      await context.read<ListRepository>().addProfile(newProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<ListRepository>();
    final items = repository.profiles;

    Widget content = const Center(child: Text('No Meetings added yet.'));

    if (items.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final profile = items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Dismissible(
              key: ValueKey(
                '${profile.name}-${profile.date}-${profile.time}-$index',
              ),
              background: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.edit, color: Colors.white, size: 28),
                ),
              ),
              secondaryBackground: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Meeting'),
                          content: const Text(
                            'Are you sure you want to delete this meeting?',
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
                }

                if (direction == DismissDirection.startToEnd) {
                  final ok = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Edit Meeting'),
                          content: const Text(
                            'Do you want to edit this meeting?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (!ok) return false;
                  if (!mounted) return false;

                  final updatedProfile = await Navigator.push<Profile>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          editpage.Edit(existingProfile: profile),
                    ),
                  );

                  if (updatedProfile != null && mounted) {
                    await context
                        .read<ListRepository>()
                        .updateProfileAt(index, updatedProfile);
                  }
                  return false;
                }
                return false;
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  repository.removeProfileAt(index);
                }
              },
              child: MeetingCard(
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
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 46, 122, 246),
              Color(0xFF45ABF0),
              Color(0xFFE8F2FF),
            ],
          ),
        ),
        child: Column(
          children: [
            const _HeaderWave(),
            Expanded(child: content),
          ],
        ),
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

class MeetingCard extends StatelessWidget {
  const MeetingCard({super.key, required this.profile, this.onTap});
  final VoidCallback? onTap;
  final Profile profile;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "";
    final a = parts[0].isNotEmpty ? parts[0][0] : "";
    final b = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : "";
    return (a + b).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initials(profile.name);
    final tag = profile.interests.isNotEmpty ? profile.interests.first : "No Tag";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF2E7AF6), Color(0xFF45ABF0), Color(0xFF4DD7FF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withAlpha(64),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              profile.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            profile.date,
                            style: TextStyle(
                              color: Colors.white.withAlpha(217),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tag,
                        style: TextStyle(
                          color: Colors.white.withAlpha(179),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
