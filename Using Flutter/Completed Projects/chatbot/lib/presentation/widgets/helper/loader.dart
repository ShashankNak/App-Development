import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return LottieBuilder.asset(
      isDark ? "assets/lottie/loading2.json" : "assets/lottie/loading.json",
      repeat: true,
      fit: BoxFit.contain,
      frameRate: FrameRate.max,
    );
  }
}
