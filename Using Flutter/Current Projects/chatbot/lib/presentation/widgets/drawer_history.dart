import 'dart:developer';

import 'package:chatbot/controller/chat_controller.dart';
import 'package:chatbot/presentation/widgets/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerHistory extends StatelessWidget {
  const DrawerHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Drawer(
        backgroundColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 15,
            ),
            ListTile(
              onTap: () {
                log("pressed");
              },
              title: const Text(
                "New Chat",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.edit_square,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: chatController.timeHistory.value.length,
                  itemBuilder: (context, index) {
                    final items = chatController.timeHistory.value;
                    return ListTile(
                      onTap: () {
                        log("pressed");
                      },
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            chatController.deleteChat(items[index]),
                      ),
                      title: Text(
                        items[index].title,
                        style: TextStyle(
                            fontSize: size.width / 30, color: Colors.white),
                      ),
                      subtitle: Text(
                        timeGetter(items[index].time, context),
                        style: TextStyle(
                            fontSize: size.width / 30, color: Colors.white),
                      ),
                    );
                  }),
            ),
            const Divider(thickness: 3),
            Text(
              "Delete All",
              style: TextStyle(
                  color: Colors.white, fontSize: size.aspectRatio * 50),
            ),
            SizedBox(
              height: size.height / 30,
            ),
          ],
        ),
      ),
    );
  }
}
