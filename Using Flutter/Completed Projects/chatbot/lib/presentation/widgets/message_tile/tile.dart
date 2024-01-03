import 'dart:io';

import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/presentation/widgets/speechButtons/speech_buttons.dart';
import 'package:chatbot/utils/colors.dart';
import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  const TextTile({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.shortestSide / 30),
        child: Column(
          crossAxisAlignment: chatModel.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.longestSide / 70,
            ),
            Text(
              chatModel.isMe ? "Me" : "Gemini",
              style: TextStyle(
                  fontSize: size.shortestSide / 30,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            SizedBox(
              height: size.longestSide / 98,
            ),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? chatModel.isMe
                        ? meChatColor
                        : aiChatColor
                    : chatModel.isMe
                        ? meLightChatColor
                        : aiLightChatColor,
                borderRadius: chatModel.isMe
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20))
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: chatModel.isMe
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(size.width / 25),
                    child: chatModel.img == ""
                        ? Text(
                            chatModel.text,
                            style: TextStyle(
                                fontSize: size.shortestSide / 25,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          )
                        : SizedBox(
                            width: size.shortestSide / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.file(
                                  File(chatModel.img),
                                  height: size.shortestSide / 2,
                                  width: size.shortestSide / 2,
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    // Handle errors, log information, or display a placeholder image.
                                    return const Text('Error loading image');
                                  },
                                ),
                                SizedBox(
                                  height: size.longestSide / 60,
                                ),
                                Text(
                                  chatModel.text,
                                  style: TextStyle(
                                      fontSize: size.shortestSide / 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SpeechButtons(chatModel: chatModel)
                ],
              ),
            ),
            SizedBox(
              height: size.longestSide / 70,
            ),
          ],
        ));
  }
}
