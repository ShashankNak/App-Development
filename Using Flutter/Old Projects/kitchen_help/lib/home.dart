import 'package:flutter/material.dart';
import 'package:kitchen_help/dining.dart';
import 'package:kitchen_help/kitchen.dart';
import 'package:kitchen_help/planner.dart';
import 'package:kitchen_help/profile.dart';
import 'package:kitchen_help/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _pages = [
    {
      'page': const Kitchen(),
      'title': 'Kitchen',
    },
  ];
  int _selectPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': const Kitchen(),
        'title': 'Kitchen',
      },
      {
        'page': const Recipe(),
        'title': 'Recipe',
      },
      {
        'page': const Planner(),
        'title': 'Planner',
      },
      {
        'page': const Dining(),
        'title': 'Dining',
      },
      {
        'page': const Profile(),
        'title': 'Profile',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          type: BottomNavigationBarType.shifting,
          onTap: _selectPage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          // type: BottomNavigationBarType.shifting,
          currentIndex: _selectPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.kitchen),
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: "Kitchen",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.cookie_outlined),
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: "Recipe",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month),
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: "Planner",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.restaurant_menu),
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: "Dining",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: "Profile",
            ),
          ]),
    );
  }
}
