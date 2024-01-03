import 'package:chatbot/controller/text_to_speech_controller.dart';
import 'package:chatbot/database/chat_storage.dart';
import 'package:chatbot/presentation/widgets/helper/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceChangeScreen extends StatefulWidget {
  const VoiceChangeScreen({super.key});

  @override
  State<VoiceChangeScreen> createState() => _VoiceChangeScreenState();
}

class _VoiceChangeScreenState extends State<VoiceChangeScreen> {
  final TextToSpeechController controller = Get.find<TextToSpeechController>();

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {
                        controller.stopAll();
                        Get.back(result: controller.voice.value.locale);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Get.theme.colorScheme.onBackground,
                      )),
                  backgroundColor: Get.theme.colorScheme.background,
                  centerTitle: true,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Choose a voice",
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                            fontSize: size.shortestSide / 16),
                      ),
                      Text(
                        "You can change this later",
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                            fontSize: size.shortestSide / 35),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          ChatHistoryStorage.setVoice(controller.voice.value);
                          Get.snackbar("", "",
                              titleText: Text(
                                "Voice Changed: ${controller.voice.value.locale}",
                                style: Get.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              messageText: Text(
                                controller.voice.value.name,
                                style: Get.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.grey[800]);
                        },
                        icon: const Icon(Icons.check)),
                    IconButton(
                      onPressed: () {
                        controller.isPlaying(!controller.isPlaying.value);
                        controller.update();

                        controller.flutterTts.value.stop();
                      },
                      icon: Icon(controller.isPlaying.value
                          ? Icons.volume_up_outlined
                          : Icons.volume_off_outlined),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.voicesList.value.length,
                        itemBuilder: (context, index) {
                          final item = controller.voicesList.value[index];
                          return ListTile(
                            selected: !compareToStringVoice(
                                item, controller.voice.value),
                            tileColor: Get.isDarkMode
                                ? Colors.white24
                                : Colors.black38,
                            onTap: () => controller.changeVoiceOnList(item),
                            title: Text(
                              item.locale,
                              style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground,
                                fontSize: size.shortestSide / 20,
                              ),
                            ),
                            subtitle: Text(
                              item.name,
                              style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground,
                                fontSize: size.shortestSide / 30,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Get.theme.colorScheme.onBackground,
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
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )),
            ],
          );
        });
  }
}
