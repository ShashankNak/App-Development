import 'dart:developer';
import 'package:chatbot/controller/chat_controller.dart';
import 'package:chatbot/database/chat_storage.dart';
// import 'package:chatbot/database/hive_storage.dart';
import 'package:chatbot/model/time_model.dart';
import 'package:chatbot/presentation/widgets/drawer_history.dart';
import 'package:chatbot/presentation/widgets/keyboard.dart';
import 'package:chatbot/presentation/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.timehistory});
  final List<TimeModel> timehistory;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ChatController controller = Get.put(ChatController());

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
    // if (AppLifecycleState.resumed == state) {
    //   controller.onResumed();
    //   log(state.toString());
    // }

    if (AppLifecycleState.inactive == state) {
      controller.onPaused();
      log(state.toString());
    }

    if (AppLifecycleState.detached == state) {
      controller.onDetached();
      log(state.toString());
    }

    if (AppLifecycleState.paused == state) {
      controller.onPaused();
      log(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 52, 53, 65),
          drawer: const DrawerHistory(),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 52, 53, 65),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () async {
                    log((await ChatHistoryStorage.clear()).toString());
                    await ChatHistoryStorage.setisNew(true);
                    controller.onResumed();
                  },
                  icon: const Icon(Icons.clear)),
            ],
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.edit_square,
                    color: Colors.white60,
                  ), // Replace with your custom icon
                  onPressed: controller.isLoading.value
                      ? () {}
                      : () {
                          Scaffold.of(context).openDrawer();
                        },
                );
              },
            ),
            title: Text(
              "Chat BOT",
              style: TextStyle(fontSize: size.width / 15, color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: controller.textList.value.isEmpty
                    ? const Center(
                        child: Text("Start Chat"),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          controller.checkonTop();
                          return true;
                        },
                        child: ListView.builder(
                          reverse: true,
                          controller: controller.scrollController.value,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.textList.value.length,
                          itemBuilder: (context, index) {
                            return TextTile(
                                chatModel: controller.textList.value[index]);
                          },
                        ),
                      ),
              ),
              controller.isLoading.value
                  ? SizedBox(
                      height: size.width / 20,
                      width: size.width / 20,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox.shrink(),
              const Divider(),
              const Keyboard()
            ],
          ),
          floatingActionButton: controller.isDisappear.value
              ? null
              : Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FloatingActionButton.small(
                    splashColor: const Color.fromARGB(82, 96, 125, 139),
                    onPressed: controller.isDisappear.value
                        ? () {}
                        : controller.scrollToTop,
                    backgroundColor: const Color.fromARGB(66, 255, 255, 255),
                    child: const Icon(
                      Icons.arrow_circle_up,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
