import 'package:flutter/material.dart';
import 'package:nasa_app/screens/start/animated_start_screen.dart';
// import 'package:nasa_app/home_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedStartScreen(),
    );
  }
}
