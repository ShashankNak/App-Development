import 'package:chatbot/controller/text_to_speech_controller.dart';
import 'package:chatbot/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum TtsState { playing, stopped }

class SpeechButtons extends StatefulWidget {
  const SpeechButtons({super.key, required this.chatModel});
  final ChatModel chatModel;
  @override
  State<SpeechButtons> createState() => _SpeechButtonsState();
}

class _SpeechButtonsState extends State<SpeechButtons>
    with WidgetsBindingObserver {
  final TextToSpeechController controller = Get.find<TextToSpeechController>();

  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Dispose of the ScrollController when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.inactive == state) {
      controller.stopAll();
    }

    if (AppLifecycleState.paused == state) {
      controller.stopAll();
    }
  }

  Future<void> speak(String text) async {
    await Future.delayed(
      Duration.zero,
      () async {
        setState(() {
          ttsState = TtsState.playing;
          controller.isPlaying(true);
          controller.update();
        });

        var result = await controller.flutterTts.value.speak(text);
        if (result == 1) {
          setState(() {
            ttsState = TtsState.stopped;
            controller.isPlaying(false);
            controller.update();
          });
        }
      },
    );
  }

  Future<void> stop() async {
    await Future.delayed(
      Duration.zero,
      () async {
        var result = await controller.flutterTts.value.stop();
        if (result == 1) {
          setState(() {
            ttsState = TtsState.stopped;
            controller.isPlaying(false);
            controller.update();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GetBuilder(
        init: controller,
        builder: (context) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.chatModel.text));
                  Get.snackbar("Copied to ClipBoard", "",
                      messageText: Text(
                        widget.chatModel.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground),
                      ),
                      snackPosition: SnackPosition.BOTTOM);
                },
                icon: Icon(
                  Icons.copy,
                  color: isDark ? Colors.white38 : Colors.black54,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.stopAll();
                  speak(widget.chatModel.text);
                },
                icon: Icon(
                  Icons.volume_up,
                  color: isDark ? Colors.white38 : Colors.black54,
                ),
              ),
            ],
          );
        });
  }
}
