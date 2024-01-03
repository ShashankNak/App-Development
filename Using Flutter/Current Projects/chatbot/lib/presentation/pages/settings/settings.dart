import 'package:chatbot/controller/chat_controller.dart';
import 'package:chatbot/controller/text_to_speech_controller.dart';
import 'package:chatbot/presentation/pages/about/about_us.dart';
import 'package:chatbot/presentation/pages/settings/voices_edit/voice_change_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    final size = MediaQuery.of(context).size;

    return GetBuilder(
        init: controller,
        builder: (context) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Get.theme.colorScheme.background,
                appBar: AppBar(
                  leading: IconButton(
                      onPressed:
                          controller.isLoading.value ? () {} : () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Get.theme.colorScheme.onBackground,
                      )),
                  backgroundColor: Get.theme.colorScheme.background,
                  title: Text(
                    "Settings",
                    style: Get.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onBackground,
                        fontSize: size.shortestSide / 15),
                  ),
                ),
                body: ListView(
                  children: [
                    SizedBox(
                      height: size.longestSide / 80,
                    ),
                    ListTile(
                      onTap: () => Get.to(() => const AboutUsScreen()),
                      leading: Image.asset(
                        Get.isDarkMode
                            ? "assets/images/dark_icon.png"
                            : "assets/images/light_icon.png",
                        width: size.shortestSide / 8,
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        "View Details",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 25,
                        ),
                      ),
                      trailing: const Icon(Icons.more_vert),
                    ),
                    SizedBox(
                      height: size.longestSide / 80,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.shortestSide / 20),
                      child: Text(
                        "Chat",
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                            fontSize: size.shortestSide / 15,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    ListTile(
                      onTap: controller.isLoading.value
                          ? () {}
                          : controller.deleteAllChatHistory,
                      leading: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      title: Text(
                        "Delete History",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 20,
                        ),
                      ),
                      subtitle: Text(
                        "Delete all the chats permanently",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 30,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: controller.removeApi,
                      leading: Icon(
                        Icons.key_off_outlined,
                        color: Get.theme.colorScheme.onBackground,
                      ),
                      title: Text(
                        "Remove API Key",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 20,
                        ),
                      ),
                      subtitle: Text(
                        "Be carefull Api key is not saved",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.longestSide / 80,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.shortestSide / 20),
                      child: Text(
                        "Speech",
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                            fontSize: size.shortestSide / 15,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(() => const VoiceChangeScreen(),
                                transition: Transition.rightToLeftWithFade)!
                            .then((value) {});
                      },
                      leading: Icon(
                        Icons.voice_chat,
                        color: Get.theme.colorScheme.onBackground,
                      ),
                      title: Text(
                        "Voice",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 20,
                        ),
                      ),
                      subtitle: Text(
                        Get.find<TextToSpeechController>().voice.value.locale,
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                          fontSize: size.shortestSide / 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                Container(
                    width: size.shortestSide,
                    height: size.longestSide,
                    color: const Color.fromARGB(193, 255, 255, 255),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    )),
            ],
          );
        });
  }
}
