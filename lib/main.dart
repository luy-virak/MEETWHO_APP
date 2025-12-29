import 'package:flutter/material.dart';
import 'package:meetwho/ui/list.dart' as pages;

void main() {
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
        scaffoldBackgroundColor: Colors
            .transparent, // IMPORTANT so Scaffold doesn't cover the gradient
      ),

      // Wrap every screen with the same background
      builder: (context, child) {
        return MeetWhoBackground(child: child ?? const SizedBox());
      },

      home: const pages.List(),
    );
  }
}

// ===== Background widget (ONLY background) =====
class MeetWhoBackground extends StatelessWidget {
  const MeetWhoBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
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
      ],
    );
  }
}
