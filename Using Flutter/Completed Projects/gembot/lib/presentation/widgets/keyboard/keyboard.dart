import 'package:chatbot/presentation/widgets/send_button/send_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatbot/controller/chat_controller.dart';
import 'package:image_picker/image_picker.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.longestSide / 80),
      child: Row(
        children: [
          SizedBox(
            width: size.shortestSide / 30,
          ),
          Expanded(
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.shortestSide / 10),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: size.shortestSide / 20),
                child: TextField(
                  onTap: () {
                    if (chatController.textList.value.isNotEmpty) {
                      chatController.scrollToBottom();
                    }
                  },
                  enabled: !chatController.isLoading.value,
                  controller: chatController.textEditingController.value,
                  cursorColor: theme.colorScheme.onBackground,
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: size.longestSide / 50,
                      color: theme.colorScheme.onBackground),
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: chatController.isLoading.value
                                    ? () {}
                                    : () => chatController
                                        .imageGenerate(ImageSource.camera),
                                icon: Icon(
                                  Icons.camera,
                                  size: size.shortestSide / 15,
                                  color: theme.colorScheme.onBackground,
                                )),
                            IconButton(
                                onPressed: chatController.isLoading.value
                                    ? () {}
                                    : () => chatController
                                        .imageGenerate(ImageSource.gallery),
                                icon: Icon(
                                  Icons.image,
                                  size: size.shortestSide / 15,
                                  color: theme.colorScheme.onBackground,
                                )),
                          ],
                        ),
                      ),
                    ),
                    label: Text(
                      "Type Here...",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: theme.colorScheme.onBackground),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.shortestSide / 70,
          ),
          SendButton(
            send: chatController.chatGenerating,
            icon: Icons.arrow_upward_outlined,
          ),
          SizedBox(
            width: size.shortestSide / 70,
          ),
        ],
      ),
    );
  }
}
