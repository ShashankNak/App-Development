import 'package:flutter/material.dart';
import 'package:nasa_app/auth/auth_widgets.dart';
import 'package:nasa_app/widgets/home_text.dart';

class AnimatedStartScreen extends StatefulWidget {
  const AnimatedStartScreen({super.key});

  @override
  State<AnimatedStartScreen> createState() => _AnimatedStartScreenState();
}

class _AnimatedStartScreenState extends State<AnimatedStartScreen>
    with TickerProviderStateMixin {
  bool selected = false;
  double? top;
  double? right;
  double? bottom;
  double? left;
  @override
  void initState() {
    super.initState();
    top = -400; // Set the initial position
    right = -800;
    bottom = -400; // Set the initial position
    left = -800;
    // Give it a small delay to initiate animation after the widget builds
    Future.delayed(const Duration(microseconds: 10), () {
      setState(() {
        top = -200;
        right = -450;
        bottom = -50; // Set the initial position
        left = -350;
      });
    });
  }

  void bottomSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => const AuthForm(),
    );
    // showBottomSheet(
    //   context: context,
    //   builder: (context) => const AuthForm(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: size.height,
              width: size.width,
              child: Image.asset(
                "assets/images/bg_image2.jpg",
                fit: BoxFit.none,
                scale: 1,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              bottom: bottom,
              left: left,
              height: size.height,
              child: Image.asset(
                'assets/images/moon.png',
                fit: BoxFit.none,
                scale: 4,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: top,
              right: right,
              height: size.height,
              child: Image.asset(
                'assets/images/earth.png',
                fit: BoxFit.none,
                scale: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: size.height / 5),
              child: const HomeText(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: size.height / 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width / 1.4, size.height / 20),
                  shadowColor: Colors.white,
                  backgroundColor: Colors.white,
                  elevation: 10,
                ),
                onPressed: bottomSheet,
                child: Text(
                  "Get Started",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: size.width / 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
