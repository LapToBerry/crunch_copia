import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState()
      => _NavigationScreenState();
}

class _NavigationScreenState
    extends State<NavigationScreen> {

  int currentIndex = 0;

  final pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Explorar",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}