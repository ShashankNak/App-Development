import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class HomeText extends StatelessWidget {
  const HomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Chat-I/O',
              textStyle: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30),
              speed: const Duration(milliseconds: 200),
            ),
          ],
          repeatForever: true,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
        ),
      ),
    );
  }
}
