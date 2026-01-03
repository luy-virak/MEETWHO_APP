import 'package:flutter/material.dart';
import 'package:meetwho/ui/navbar/foot_navbar.dart' as pages;
import 'package:meetwho/data/list_repository.dart' as repository;
import 'package:meetwho/data/list_repository.dart' as repository;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await repository.loadProfiles(); // <-- load JSON file into dummylistitem
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetWho',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent, // IMPORTANT so Scaffold doesn't cover the gradient
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const pages.FootNavbar(),
    );
  }
}
