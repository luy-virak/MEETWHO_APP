import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:meetwho/ui/list.dart' as pages;

class FootNavbar extends StatefulWidget {
  const FootNavbar({super.key});

  @override
  State<FootNavbar> createState() => _FootNavbarState();
}

class _FootNavbarState extends State<FootNavbar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    pages.List(),
    Center(child: Text('Search Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true, // makes the nav look more "floating"
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CircleNavBar(
        activeIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),

        activeIcons: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.history, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        inactiveIcons: const [
          Icon(Icons.home_outlined, color: Colors.black54),
          Icon(Icons.history_outlined, color: Colors.black54),
          Icon(Icons.person_outline, color: Colors.black54),
        ],

        // style
        color: Colors.white,
        circleColor: Colors.white,
        height: 80,
        circleWidth: 60,
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.blue,
        circleShadowColor: Colors.blue,
        elevation: 10,

        // gradients (optional)
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 47, 128, 237),
            Color.fromARGB(255, 49, 132, 237),
            Color.fromARGB(255, 86, 204, 242),
          ],
        ),
        circleGradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 47, 128, 237),
            Color.fromARGB(255, 49, 132, 237),
            Color.fromARGB(255, 86, 204, 242),
          ],
        ),
      ),
    );
  }
}
