// import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:io';

import 'package:chatbot/model/chat_model.dart';
import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  const TextTile({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width / 30),
        child: Column(
          crossAxisAlignment: chatModel.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 70,
            ),
            Text(
              chatModel.isMe ? "Me" : "Gemini",
              style: TextStyle(fontSize: size.width / 30, color: Colors.white),
            ),
            SizedBox(
              height: size.height / 98,
            ),
            Container(
              decoration: BoxDecoration(
                color: chatModel.isMe
                    ? const Color.fromARGB(255, 47, 67, 76)
                    : const Color.fromARGB(255, 23, 43, 57),
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
              child: Padding(
                  padding: EdgeInsets.all(size.width / 25),
                  child: chatModel.img == ""
                      ? Text(
                          chatModel.text,
                          style: TextStyle(
                              fontSize: size.width / 25, color: Colors.white),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.file(
                              File(chatModel.img),
                              height: size.width / 2,
                              width: size.width / 2,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: size.height / 60,
                            ),
                            Text(
                              chatModel.text,
                              style: TextStyle(
                                  fontSize: size.width / 25,
                                  color: Colors.white),
                            ),
                          ],
                        )
                  // : AnimatedTextKit(
                  //     animatedTexts: [
                  //       TypewriterAnimatedText(
                  //         "Please wait...",
                  //         textStyle: TextStyle(
                  //             color: Colors.white, fontSize: size.width / 25),
                  //         speed: const Duration(milliseconds: 100),
                  //       ),
                  //     ],
                  //     repeatForever: true,
                  //     displayFullTextOnTap: true,
                  //     stopPauseOnTap: true,
                  //     onTap: () {
                  //       // print("Tap Event");
                  //     },
                  //   ),
                  ),
            ),
            SizedBox(
              height: size.height / 70,
            ),
          ],
        ));
  }
}
