import 'dart:developer';

import 'package:chatbot/Api/api.dart';
import 'package:chatbot/database/chat_storage.dart';
import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/model/time_model.dart';
import 'package:chatbot/presentation/pages/image_upload_screen.dart';
import 'package:chatbot/presentation/widgets/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  var textList = Rx<List<ChatModel>>([]);
  var isLoading = false.obs;
  var isDisappear = true.obs;
  var scrollController = ScrollController().obs;
  var textEditingController = TextEditingController().obs;
  var timeHistory = Rx<List<TimeModel>>([]);
  var time = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeList();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.update((val) {
      val!.dispose();
    });
    textEditingController.update((val) {
      val!.dispose();
    });
  }

  void scrollToTop() {
    isDisappear(true);
    scrollController.update((val) {
      val!.animateTo(
        scrollController.value.position.maxScrollExtent,
        duration: const Duration(
            milliseconds: 600), // You can adjust the duration as needed
        curve: Curves.easeInOut,
      );
    });
  }

  void checkonTop() {
    try {
      if (textList.value.isNotEmpty &&
          scrollController.value.offset <
              scrollController.value.position.maxScrollExtent - 100 &&
          isDisappear.value) {
        isDisappear(false);
      }

      if (textList.value.isNotEmpty &&
          scrollController.value.offset ==
              scrollController.value.position.maxScrollExtent &&
          !isDisappear.value) {
        isDisappear(true);
      }
    } catch (e) {
      log("scroll error");
    }
  }

  Future<void> geminiGenerate(ChatModel chatModel) async {
    try {
      log("before: ${isLoading.value.toString()}");
      isLoading(true);
      log("after: ${isLoading.value.toString()}");

      final value = await Api.getResponse(textList.value, chatModel);
      onPaused();
      log(value);
      makeTile(ChatModel(text: value, isMe: false, img: ''));

      log("before: ${isLoading.value.toString()}");
      isLoading(false);
      log("after: ${isLoading.value.toString()}");
    } catch (e) {
      log(e.toString());
      makeTile(ChatModel(text: e.toString(), isMe: false, img: ''));
      isLoading(false);
      log(isLoading.value.toString());
    }
  }

  void makeTile(ChatModel chatModel) {
    textList.update((val) {
      val!.insert(0, chatModel);
    });
  }

  void imageGenerate() async {
    log("image Generating");
    final ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        final chat = await Get.to(
            () => ImageUploadScreen(
                file: value, text: textEditingController.value.text.trim()),
            transition: Transition.rightToLeftWithFade);
        textEditingController.update((val) => val!.clear());
        if (chat != null) {
          makeTile(chat);
          geminiGenerate(chat);
        }
      }
    });
  }

  void chatGenerating() {
    log("Chat Generating");
    final text = textEditingController.value.text.trim();
    textEditingController.update((val) => val!.clear());
    if (text.isNotEmpty) {
      makeTile(ChatModel(text: text, isMe: true, img: ''));
      geminiGenerate(ChatModel(text: text, isMe: true, img: ''));
    }
    Get.focusScope!.unfocus();
  }

  String getDate(int index) {
    String newDate = '';
    bool isSameDay = false;
    if (index == timeHistory.value.length - 1) {
      newDate = dateGetter(timeHistory.value[index].time);
    } else {
      final date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(timeHistory.value[index].time));
      final prevdate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(timeHistory.value[index + 1].time));
      isSameDay = (date.day == prevdate.day) &&
          (date.month == prevdate.month) &&
          (date.year == prevdate.year);
      newDate = isSameDay ? '' : dateGetter(timeHistory.value[index].time);
      if (index == 0) {
        newDate = isSameDay ? "" : dateGetter(timeHistory.value[index].time);
      } else {
        newDate =
            isSameDay ? '' : dateGetter(timeHistory.value[index - 1].time);
      }
    }
    return newDate;
  }

  void initializeList() async {
    await ChatHistoryStorage.setisNew(true);
    final value = await ChatHistoryStorage.getTimeHistory();
    timeHistory(value);
    log("timeHistory: ${timeHistory.value.length}");

    time(DateTime.now().millisecondsSinceEpoch.toString());
    log("Time value: ${time.value}");
  }

  void onResumed() async {
    isLoading(true);
    final boolisNew = await ChatHistoryStorage.getisNew();
    timeHistory(await ChatHistoryStorage.getTimeHistory());
    if (timeHistory.value.isNotEmpty && !boolisNew) {
      textList(await ChatHistoryStorage.getChatHistory(
          timeHistory.value.first.time));
    } else {
      textList([]);
    }
    isLoading(false);
  }

  void onDetached() async {
    if (textList.value.isNotEmpty) {
      isLoading(true);
      await ChatHistoryStorage.setisNew(true);
      isLoading(false);
    }
  }

  void onPaused() async {
    if (textList.value.isNotEmpty) {
      log("ONPAUSED_----->");
      isLoading(true);

      final boolisNew = await ChatHistoryStorage.getisNew();
      if (boolisNew) {
        timeHistory.update((val) {
          val!.insert(
              0, TimeModel(title: textList.value.last.text, time: time.value));
        });
        await ChatHistoryStorage.saveTimeHistory(timeHistory.value);
        await ChatHistoryStorage.setisNew(false);
      }
      await ChatHistoryStorage.saveChatHistory(textList.value, time.value);
      isLoading(false);
    }
  }

  void deleteChat(TimeModel item) async {
    if (await ChatHistoryStorage.removeChat(item.time)) {
      timeHistory.update((val) {
        val!.removeWhere((element) => element.time == item.time);
      });
      log("Chat Deleted");
      await ChatHistoryStorage.saveTimeHistory(timeHistory.value);
      if (time.value == item.time) {
        await ChatHistoryStorage.setisNew(true);
        textList([]);
      }
    }
  }
}
