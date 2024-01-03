import 'dart:io';
import 'dart:developer';

import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/presentation/widgets/send_button/send_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp
      ]);
    }
    super.dispose();
  }
  //for picking and compressing image

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              )),
          title: Text(
            "Edit Image",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: size.longestSide / 30,
                color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SizedBox(
          height: size.longestSide,
          width: size.shortestSide,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: size.longestSide / 10,
                ),
                Image.file(
                  File(widget.file.path),
                  width: size.shortestSide,
                  height: size.longestSide / 1.7,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: size.longestSide / 60,
                ),
                messageInput(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget messageInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.longestSide / 90,
        horizontal: size.shortestSide / 90,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.shortestSide / 10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                child: TextField(
                  controller: _messageController,
                  cursorColor: Theme.of(context).colorScheme.onBackground,
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: size.longestSide / 50,
                      color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    label: Text(
                      "Type Here...",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.shortestSide / 90,
          ),
          SendButton(
            send: () {
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
                img: widget.file.path,
              ));
            },
            icon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }
}
