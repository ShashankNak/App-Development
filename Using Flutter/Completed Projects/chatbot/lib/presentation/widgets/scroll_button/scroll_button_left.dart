import 'package:chatbot/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollButtonLeft extends StatelessWidget {
  const ScrollButtonLeft({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: FloatingActionButton.small(
        backgroundColor: isDark ? Colors.white10 : Colors.black26,
        onPressed: controller.isDisappearLeft.value
            ? () {}
            : controller.scrollToBottom,
        child: Icon(
          Icons.arrow_circle_down,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
