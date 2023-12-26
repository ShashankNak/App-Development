import 'dart:io';
import 'dart:developer';

import 'package:chatbot/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key, required this.file, required this.text});
  final XFile file;
  final String text;

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  late TextEditingController _messageController;
  int counter = 0;
  bool time = false;
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  //for picking and compressing image

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 52, 53, 65),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          title: Text(
            "Edit Image",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: size.height / 30, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 52, 53, 65),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Image.file(
                  File(widget.file.path),
                  width: size.width,
                  height: size.height / 1.7,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: size.height / 60,
                ),
                messageInput(isDark, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget messageInput(bool isDark, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height / 90,
        horizontal: size.width / 90,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 52, 53, 65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width / 30),
                side: const BorderSide(color: Colors.white),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                child: TextField(
                  controller: _messageController,
                  cursorColor: Colors.white,
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: size.height / 50, color: Colors.white),
                  decoration: InputDecoration(
                    label: Text(
                      "Type Here...",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.white),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width / 90,
          ),
          MaterialButton(
            color: const Color.fromARGB(255, 52, 53, 65),
            height: size.width / 6,
            minWidth: size.width / 6,
            shape: const CircleBorder(side: BorderSide(color: Colors.white)),
            onPressed: () {
              if (_messageController.text.trim().isEmpty) {
                _messageController.clear();
                FocusScope.of(context).unfocus();
                log("Write something");
                return;
              }
              Get.back<ChatModel>(
                  result: ChatModel(
                      text: _messageController.text.trim(),
                      isMe: true,
                      img: widget.file.path));
            },
            child: Icon(
              Icons.rocket_launch_sharp,
              color: Colors.white,
              size: size.width / 12,
            ),
          )
        ],
      ),
    );
  }
}
