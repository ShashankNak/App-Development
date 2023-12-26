import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatbot/controller/chat_controller.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height / 80),
      child: Row(
        children: [
          SizedBox(
            width: size.width / 30,
          ),
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 52, 53, 65),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width / 30),
                  side: const BorderSide(color: Colors.white)),
              child: Padding(
                padding: EdgeInsets.only(left: size.width / 20),
                child: TextField(
                  enabled: !chatController.isLoading.value,
                  controller: chatController.textEditingController.value,
                  cursorColor: Colors.white,
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: size.height / 50, color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: chatController.isLoading.value
                              ? () {}
                              : chatController.imageGenerate,
                          icon: Icon(
                            Icons.image,
                            size: size.width / 15,
                            color: Colors.white,
                          )),
                    ),
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
            width: size.width / 70,
          ),
          MaterialButton(
            color: const Color.fromARGB(255, 52, 53, 65),
            height: size.width / 6,
            minWidth: size.width / 6,
            shape: const CircleBorder(side: BorderSide(color: Colors.white)),
            onPressed: chatController.chatGenerating,
            child: Icon(
              Icons.rocket_launch_sharp,
              size: size.width / 14,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
