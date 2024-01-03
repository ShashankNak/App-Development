import 'dart:async';
import 'dart:developer' as dv;
import 'package:chatbot/database/chat_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Api/api.dart';
import '../presentation/pages/chat/chat.dart';

class StartScreenController extends GetxController {
  var textEditingController =
      Rx<TextEditingController>(TextEditingController());
  var isLoading = false.obs;

  Future<void> launchInBrowser(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      dv.log(e.toString());
      Get.snackbar("URL Error", "Try Again Later");
    }
  }

  //verifying api key
  Future checkAPI() async {
    final value = textEditingController.value.text.trim();
    textEditingController.update((val) => val!.clear());
    Get.focusScope!.unfocus();
    isLoading(true);
    update();

    if (await Api.checkApiKey(value)) {
      if (await ChatHistoryStorage.setApiKey(value)) {
        Gemini.init(apiKey: value, enableDebugging: true);
        isLoading(false);
        update();
        Get.off(() => const ChatScreen(timehistory: []),
            transition: Transition.rightToLeftWithFade);
      } else {
        isLoading(false);
        update();
        Get.snackbar("", "",
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text(
              "Storage Error",
              style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
            messageText: Text(
              "Please Try again later",
              style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.grey[800]);
      }
    } else {
      isLoading(false);
      update();
      Get.snackbar("", "",
          titleText: Text(
            "Invalid API Key",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          messageText: Text(
            "Enter Valid Key for Using Gembot",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[800]);
    }

    return;
  }
}
