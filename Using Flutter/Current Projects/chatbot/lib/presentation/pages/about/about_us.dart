import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Get.size.shortestSide / 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  Get.isDarkMode
                      ? "assets/images/dark_icon.png"
                      : "assets/images/light_icon.png",
                  fit: BoxFit.cover,
                  width: Get.size.shortestSide / 4,
                ),
              ),
              Text(
                "GemBOT",
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontSize: Get.size.shortestSide / 12,
                    color: Get.theme.colorScheme.onBackground),
              ),
              SizedBox(
                height: Get.size.longestSide / 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "General Instructions",
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontSize: Get.size.shortestSide / 20,
                      color: Get.theme.colorScheme.onBackground),
                ),
              ),
              SizedBox(
                height: Get.size.longestSide / 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "This app uses the Google Generative Language API for getting the results. It uses gemini-pro and gemini-pro-vision models",
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontSize: Get.size.shortestSide / 20,
                      color: Get.theme.colorScheme.onBackground),
                ),
              ),
              SizedBox(
                height: Get.size.longestSide / 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "It uses flutter gemini package for getting the chats, text and image to text generation.",
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontSize: Get.size.shortestSide / 20,
                      color: Get.theme.colorScheme.onBackground),
                ),
              ),
              SizedBox(
                height: Get.size.longestSide / 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "App Info",
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontSize: Get.size.shortestSide / 20,
                      color: Get.theme.colorScheme.onBackground),
                ),
              ),
              SizedBox(
                height: Get.size.longestSide / 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Beta version 1.0",
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontSize: Get.size.shortestSide / 20,
                      color: Get.theme.colorScheme.onBackground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
