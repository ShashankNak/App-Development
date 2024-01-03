import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot/controller/start_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/helper/consts.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  final StartScreenController controller = Get.put(StartScreenController());
  late AnimationController _animationController;
  late Color _backgroundColor;
  late Color _textColor;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _backgroundColor = _getRandomColor();
    _textColor = _getContrastingTextColor(_backgroundColor);
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (mounted) {
        setState(() {
          _backgroundColor = _getRandomColor();
          _textColor = _getContrastingTextColor(_backgroundColor);
        });
      }
    });
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  Color _getContrastingTextColor(Color bgColor) {
    // Calculate the contrast ratio (Luminance method)
    return Color.fromRGBO(
      255 - _backgroundColor.red,
      255 - _backgroundColor.green,
      255 - _backgroundColor.blue,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(
      () => Scaffold(
        backgroundColor: _backgroundColor,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) => Container(
                height: size.height,
                width: size.width,
                color: ColorTween(
                  begin: _backgroundColor,
                  end: _getRandomColor(),
                ).animate(_animationController).value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      Get.isDarkMode
                          ? "assets/images/dark_icon.png"
                          : "assets/images/light_icon.png",
                      width: size.shortestSide / 3,
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          fontSize: size.shortestSide / 9),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Let\'s Build',
                              speed: const Duration(milliseconds: 100)),
                          TypewriterAnimatedText('Let\'s Innovate',
                              speed: const Duration(milliseconds: 100)),
                          TypewriterAnimatedText('Let\'s Inspire',
                              speed: const Duration(milliseconds: 100)),
                          TypewriterAnimatedText('GemBOT',
                              speed: const Duration(milliseconds: 100)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.longestSide / 20,
                    ),
                    Flexible(
                      child: Container(
                        width: size.shortestSide,
                        height: size.longestSide / 2.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(size.shortestSide / 10),
                              topRight:
                                  Radius.circular(size.shortestSide / 10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: size.shortestSide / 15),
                                      child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize:
                                                        size.shortestSide / 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                            children: [
                                              TextSpan(
                                                  text: "Get the Api Key,\n",
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.shortestSide /
                                                              16)),
                                              TextSpan(
                                                  text:
                                                      "as the app is in Beta version",
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.shortestSide /
                                                              25)),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        color: Colors.black,
                                        onPressed: controller.isLoading.value
                                            ? () {}
                                            : () => controller
                                                .launchInBrowser(apiUrl),
                                        icon: const Icon(Icons.arrow_forward)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.longestSide / 60,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.shortestSide / 20),
                              child: TextField(
                                enabled: !controller.isLoading.value,
                                controller:
                                    controller.textEditingController.value,
                                cursorColor: Colors.black,
                                autocorrect: false,
                                maxLines: 1,
                                keyboardType: TextInputType.multiline,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: size.longestSide / 50,
                                        color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Enter Api Key......",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.black),
                                  contentPadding: const EdgeInsets.all(20),
                                  fillColor:
                                      const Color.fromARGB(248, 200, 243, 255),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: Colors.black45)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: Colors.black45)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: Colors.black45)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.longestSide / 40,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.shortestSide / 10,
                                    vertical: size.shortestSide / 40),
                                backgroundColor:
                                    const Color.fromARGB(249, 24, 24, 24),
                              ),
                              onPressed: controller.isLoading.value
                                  ? () {}
                                  : () async => await controller.checkAPI(),
                              child: Text(
                                "Get Started",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: size.shortestSide / 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isLoading.value)
              Container(
                  width: size.shortestSide,
                  height: size.longestSide,
                  color: const Color.fromARGB(193, 255, 255, 255),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
