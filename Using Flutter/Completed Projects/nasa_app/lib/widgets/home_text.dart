import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class HomeText extends StatelessWidget {
  const HomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Explore Space',
              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: size.width / 8,
                  color: Theme.of(context).colorScheme.onBackground),
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
