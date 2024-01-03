import 'dart:developer';
import 'package:chatbot/controller/chat_controller.dart';
import 'package:chatbot/controller/text_to_speech_controller.dart';
import 'package:chatbot/model/time_model.dart';
import 'package:chatbot/presentation/widgets/drawer/drawer_history.dart';
import 'package:chatbot/presentation/widgets/keyboard/keyboard.dart';
import 'package:chatbot/presentation/widgets/scroll_button/scroll_button_left.dart';
import 'package:chatbot/presentation/widgets/scroll_button/scroll_button_right.dart';
import 'package:chatbot/presentation/widgets/message_tile/tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/helper/loader.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.timehistory});
  final List<TimeModel> timehistory;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ChatController controller = Get.put(ChatController());
  final TextToSpeechController tts = Get.put(TextToSpeechController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.paused == state) {
      log(state.toString());
      await controller.savingSelectedUpdatedChat();
    }

    if (AppLifecycleState.inactive == state) {
      await controller.savingSelectedUpdatedChat();
      log(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.find<TextToSpeechController>().stopAll();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          drawer: const DrawerHistory(),
          resizeToAvoidBottomInset: size.width < size.height,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: controller.isLoading.value
                      ? () {}
                      : () {
                          tts.stopAll();
                          controller.savingSelectedUpdatedChat();

                          Scaffold.of(context).openDrawer();
                        },
                  icon: ImageIcon(
                    size: size.shortestSide / 15,
                    const AssetImage("assets/images/menu.png"),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await tts.stopAll();
                    await controller.savingSelectedUpdatedChat();
                    await controller.initializeList();
                  },
                  icon: const Icon(Icons.edit_square))
            ],
            title: Text(
              "GemBOT",
              style: TextStyle(
                  fontSize: size.shortestSide / 15,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: controller.textList.value.isEmpty
                          ? Center(
                              child: Image.asset(
                                Get.isDarkMode
                                    ? "assets/images/dark_icon.png"
                                    : "assets/images/light_icon.png",
                                fit: BoxFit.cover,
                                width: size.shortestSide / 8,
                              ),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                controller.checkonTop();
                                controller.checkonBottom();
                                return true;
                              },
                              child: ListView.builder(
                                reverse: true,
                                controller: controller.scrollController.value,
                                physics: const BouncingScrollPhysics(
                                    decelerationRate:
                                        ScrollDecelerationRate.fast),
                                itemCount: controller.textList.value.length,
                                itemBuilder: (context, index) {
                                  return TextTile(
                                      chatModel:
                                          controller.textList.value[index]);
                                },
                              ),
                            ),
                    ),
                    controller.isLoading.value
                        ? SizedBox(
                            height: size.longestSide / 15,
                            child: const Loader())
                        : const SizedBox.shrink(),
                    const Keyboard()
                  ],
                ),
                if (!controller.isDisappearRight.value)
                  const ScrollButtonRight(),
                if (!controller.isDisappearLeft.value) const ScrollButtonLeft(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
