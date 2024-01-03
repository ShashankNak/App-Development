import 'package:flutter/material.dart';

import '../screens/home.dart';

class MenuIconBar extends StatelessWidget {
  const MenuIconBar({super.key, required this.menuItem});
  final Setting menuItem;

  @override
  Widget build(BuildContext context) {
    Widget selectedIcon = const Icon(Icons.home);
    String? selectedText;
    if (menuItem == Setting.edit) {
      selectedIcon = const Icon(Icons.edit);
      selectedText = 'Create/Edit Profile';
    }
    if (menuItem == Setting.profile) {
      selectedIcon = const Icon(Icons.person);
      selectedText = 'Profile';
    }
    if (menuItem == Setting.logout) {
      selectedIcon = const Icon(Icons.exit_to_app_rounded);
      selectedText = 'Logout';
    }

    return Row(
      children: [
        selectedIcon,
        const SizedBox(
          width: 2,
        ),
        Text(selectedText!),
      ],
    );
  }
}
