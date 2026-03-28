import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetwho/ui/navigation/foot_navbar.dart' as pages;
import 'package:meetwho/data/repositories/list_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ListRepository();
  await repository.loadProfiles();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => repository,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetWho',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      builder: (context, child) {
        return MeetWhoBackground(child: child ?? const SizedBox());
      },
      home: const pages.FootNavbar(),
    );
  }
}

class MeetWhoBackground extends StatelessWidget {
  const MeetWhoBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2F80ED),
                  Color(0xFF4DBBFF),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
