import 'dart:developer';

import 'package:chatbot/controller/chat_controller.dart';
import 'package:chatbot/presentation/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/consts.dart';

class DrawerHistory extends StatelessWidget {
  const DrawerHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    final size = MediaQuery.of(context).size;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final theme = Theme.of(context);
    return GetBuilder(
        init: controller,
        builder: (context) {
          return Drawer(
            width: size.shortestSide / 1.3,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            backgroundColor: theme.colorScheme.primary,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Image.asset(
                      Get.isDarkMode
                          ? "assets/images/dark_icon.png"
                          : "assets/images/light_icon.png",
                    ),
                    title: Text(
                      "Chat History",
                      style: TextStyle(
                          fontSize: size.shortestSide / 20,
                          color: theme.colorScheme.onBackground),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  SizedBox(
                    height: size.longestSide / 90,
                  ),
                  Divider(
                    thickness: 1,
                    color: theme.colorScheme.onBackground,
                  ),
                  if (!isLandscape)
                    ListTile(
                      onTap: () {
                        log("pressed");
                        controller.initializeList();
                      },
                      title: Text(
                        "New Chat",
                        style: TextStyle(
                            fontSize: size.shortestSide / 15,
                            color: theme.colorScheme.onBackground),
                      ),
                      trailing: Icon(
                        Icons.edit_square,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  if (!isLandscape)
                    Divider(
                      thickness: 1,
                      color: theme.colorScheme.onBackground,
                    ),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 15),
                        shrinkWrap: true,
                        itemCount: controller.timeHistory.value.length,
                        itemBuilder: (context, index) {
                          final items = controller.timeHistory.value;
                          final date = controller.getDate(index);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (date != "")
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.shortestSide / 50, bottom: 5),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                        color: theme.colorScheme.onBackground,
                                        fontSize: size.shortestSide / 18),
                                  ),
                                ),
                              ListTile(
                                tileColor: controller.selectedTime.value ==
                                        items[index].time
                                    ? isDark
                                        ? Colors.white38
                                        : Colors.black12
                                    : Colors.transparent,
                                onTap: () async {
                                  controller.selectedChat(items[index].time);
                                },
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      controller.deleteChat(items[index].time),
                                ),
                                title: Text(
                                  formatTitle(items[index].title),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: size.shortestSide / 30,
                                      color: theme.colorScheme.onBackground),
                                ),
                                subtitle: Text(
                                  timeGetter(items[index].time, context),
                                  style: TextStyle(
                                      fontSize: size.shortestSide / 30,
                                      color: theme.colorScheme.onBackground),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Divider(
                    thickness: 1,
                    color: theme.colorScheme.onBackground,
                  ),
                  ListTile(
                    onTap: () async {
                      // log((await ChatHistoryStorage.clear()).toString());
                      // await controller.initializeList();
                      // await controller.initializeKey();
                      Get.to(() => const Settings(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    leading: Icon(
                      Icons.settings,
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    title: Text(
                      "Settings ",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onBackground,
                        fontSize: size.shortestSide / 15,
                      ),
                    ),
                    trailing: Icon(
                      Icons.more_horiz,
                      color: Get.theme.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
