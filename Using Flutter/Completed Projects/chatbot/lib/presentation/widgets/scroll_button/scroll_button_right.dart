import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart';

class ScrollButtonRight extends StatelessWidget {
  const ScrollButtonRight({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: FloatingActionButton.small(
        backgroundColor: isDark ? Colors.white10 : Colors.black26,
        onPressed:
            controller.isDisappearRight.value ? () {} : controller.scrollToTop,
        child: Icon(
          Icons.arrow_circle_up,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
