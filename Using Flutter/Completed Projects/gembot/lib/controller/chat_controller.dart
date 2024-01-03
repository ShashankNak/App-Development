import 'dart:developer';

import 'package:chatbot/Api/api.dart';
import 'package:chatbot/database/chat_storage.dart';
import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/model/time_model.dart';
import 'package:chatbot/presentation/pages/image_upload/image_upload_screen.dart';
import 'package:chatbot/presentation/pages/start/start_screen.dart';
import 'package:chatbot/presentation/widgets/helper/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  var textList = Rx<List<ChatModel>>([]); //storing list of chat models
  var isLoading = false.obs; //for loading purpose
  var isDisappearRight = true.obs; //for top scroller at the right
  var isDisappearLeft = true.obs; //for bottom scroller at the left
  var scrollController =
      ScrollController().obs; //scroll controller for the chat screen
  var textEditingController =
      TextEditingController().obs; //text editing controller for the keyboard
  var timeHistory = Rx<List<TimeModel>>([]);
  var time = ''.obs; //time for storing the chat
  var selectedTime = ''.obs;
  var pLL = Rx<int>(0); //previous chat list length
  var isNew = true.obs; // new chat
  var title = "".obs; //title of the chat

  @override
  void onInit() {
    super.onInit();
    initializeKey();
    initializeList();
  }

  //initializing key from the local storage
  Future initializeKey() async {
    final value = await ChatHistoryStorage.getApiKey();

    if (value != "") {
      log(value);
      Gemini.init(apiKey: value, enableDebugging: true);
    } else {
      Get.offUntil(
          GetPageRoute(
              page: () => const StartScreen(),
              transition: Transition.leftToRightWithFade),
          (route) => false);
    }
  }

  //disposing controllers
  @override
  void dispose() {
    super.dispose();
    scrollController.update((val) {
      val!.dispose();
    });
    textEditingController.update((val) {
      val!.dispose();
    });
  }

  //initalizing new list,new time and other values
  Future initializeList() async {
    isNew(true);
    update();

    isDisappearRight(true);
    update();
    isDisappearLeft(true);
    update();

    final value = await ChatHistoryStorage.getTimeHistory();
    timeHistory(value);
    update();

    log("timeHistory: ${timeHistory.value.length}");

    time(DateTime.now().millisecondsSinceEpoch.toString());
    title("");
    update();
    log("Time value: ${time.value}");

    selectedTime(time.value);
    update();

    textList([]);
    update();
  }

  //scrolling user to top of the screen

  void scrollToTop() {
    isDisappearRight(true);
    update();

    scrollController.update((val) {
      val!.animateTo(
        scrollController.value.position.maxScrollExtent,
        duration: const Duration(
            milliseconds: 600), // You can adjust the duration as needed
        curve: Curves.decelerate,
      );
    });
  }

  //scrolling user to bottom of the screen
  void scrollToBottom() {
    isDisappearLeft(true);
    update();

    scrollController.update((val) {
      val!.animateTo(
        scrollController.value.position.minScrollExtent,
        duration: const Duration(
            milliseconds: 600), // You can adjust the duration as needed
        curve: Curves.decelerate,
      );
    });
  }

  //checking if user screen is at the top
  void checkonTop() {
    try {
      if (textList.value.isNotEmpty &&
          scrollController.value.offset <
              scrollController.value.position.maxScrollExtent - 100 &&
          isDisappearRight.value) {
        isDisappearRight(false);
      }

      if (textList.value.isNotEmpty &&
          scrollController.value.offset ==
              scrollController.value.position.maxScrollExtent &&
          !isDisappearRight.value) {
        isDisappearRight(true);
      }
      update();
    } catch (e) {
      log("scroll error");
    }
  }

  //checking if user screen is at the bottom
  void checkonBottom() {
    try {
      if (textList.value.isNotEmpty &&
          scrollController.value.offset >
              scrollController.value.position.minScrollExtent +
                  Get.size.longestSide &&
          isDisappearLeft.value) {
        isDisappearLeft(false);
      }

      if (textList.value.isNotEmpty &&
          scrollController.value.offset ==
              scrollController.value.position.minScrollExtent &&
          !isDisappearLeft.value) {
        isDisappearLeft(true);
      }

      update();
    } catch (e) {
      log("scroll error");
    }
  }

  //genearating the response from the api call
  Future<void> geminiGenerate(ChatModel chatModel) async {
    try {
      isLoading(true);
      update();
      await Future.delayed(Duration.zero, () async {
        //http response and request
        // final value = await Api.getApiResponse(textList.value, chatModel);

        //inbuild gemini reponse
        var value = await Api.getGeminiResponse(textList.value, chatModel);
        value = value.replaceAll("*", "");
        await makeTile(ChatModel(text: value, isMe: false, img: ""));
        isLoading(false);
        update();
        if (textList.value.length == 2) {
          List<ChatModel> newList = [];
          for (var i in textList.value) {
            newList.add(i);
          }
          newList.insert(
              0,
              ChatModel(
                  text: "Give me the title of the above chat in 3 or 4 words",
                  isMe: true,
                  img: ""));
          final agenda = await Api.getAgenda(newList);
          title(formatTitle(agenda));
          update();
          log("title: ${title.value}");
        }
      });

      if (textList.value.isNotEmpty) {
        //if minimum content then the screen then don't show the up scroll button
        scrollToBottom();
      }
    } catch (e) {
      await makeTile(ChatModel(text: e.toString(), isMe: false, img: ""));
      isLoading(false);
    }
  }

//updating list and inserting at top like stack
  Future<void> makeTile(ChatModel chatModel) async {
    await Future.delayed(
      Duration.zero,
      () {
        textList.update((val) {
          val!.insert(0, chatModel);
        });
        log("length: ${textList.value.length}");
        update();
      },
    );
  }

//getting image and compressing it and going to imageuploadscreen and uploading image for generating image info
  Future<void> imageGenerate(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    Get.focusScope!.unfocus();
    try {
      await picker.pickImage(source: source).then((value) async {
        if (value != null) {
          log("original Image: ${await value.length()}");
          log("image path: ${value.path}");
          var target = value.path;
          var li = target.split('.jpg');
          target = "${li.first}_${time.value}.jpg";
          log(target);
          final result = await FlutterImageCompress.compressAndGetFile(
            value.path,
            target,
            quality: 50,
          );
          if (result != null) {
            log("Compress Image: ${await result.length()}");
            final chat = await Get.to<ChatModel>(
                () => ImageUploadScreen(
                    file: result,
                    text: textEditingController.value.text.trim()),
                transition: Transition.rightToLeftWithFade);
            textEditingController.update((val) => val!.clear());

            if (chat != null) {
              await Future.delayed(Duration.zero, () async {
                makeTile(chat);
                geminiGenerate(chat);
              });
            }
          }
        }
      });
    } catch (e) {
      Get.snackbar("Error", "Something went Wrong");
    }
  }

//generating chat
  Future chatGenerating() async {
    final text = textEditingController.value.text.trim();
    textEditingController.update((val) => val!.clear());
    Get.focusScope!.unfocus();

    if (text.isNotEmpty) {
      await Future.delayed(Duration.zero, () async {
        await makeTile(ChatModel(text: text, isMe: true, img: ""));
        await geminiGenerate(ChatModel(text: text, isMe: true, img: ""));
        log(text);
      });
    }
  }

  //converting the time in milliseconds to date and day
  String getDate(int index) {
    String newDate = '';
    bool isSameDay = false;
    if (index == 0) {
      newDate = dateGetter(timeHistory.value[index].time);
    } else {
      final date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(timeHistory.value[index].time));
      final prevdate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(timeHistory.value[index - 1].time));
      isSameDay = (date.day == prevdate.day) &&
          (date.month == prevdate.month) &&
          (date.year == prevdate.year);
      newDate = isSameDay ? '' : dateGetter(timeHistory.value[index].time);
      if (index == timeHistory.value.length - 1) {
        newDate = isSameDay ? "" : dateGetter(timeHistory.value[index].time);
      } else {
        newDate =
            isSameDay ? '' : dateGetter(timeHistory.value[index + 1].time);
      }
    }
    return newDate;
  }

  //saving time and chat in local storage
  Future<void> saveTimeAndChat() async {
    await Future.delayed(Duration.zero, () async {
      isLoading(true);
      update();

      time(DateTime.now().millisecondsSinceEpoch.toString());
      selectedTime(time.value);
      // previousList(textList.value);
      pLL(textList.value.length);
      update();

      timeHistory.update((val) {
        val!.insert(
            0,
            TimeModel(
                title:
                    title.value == "" ? textList.value.last.text : title.value,
                time: time.value));
      });
      title("");
      update();
      await ChatHistoryStorage.saveTimeHistory(timeHistory.value);
      isNew(false);
      update();

      await ChatHistoryStorage.saveChatHistory(textList.value, time.value);
      isLoading(false);
      update();

      log("message : ${textList.value.last.text}");
      log("time: ${time.value}");
      log("Selected time: ${selectedTime.value}");
    });
  }

  //delete a particular chat
  Future deleteChat(String itemTime) async {
    await Future.delayed(
      Duration.zero,
      () async {
        if (await ChatHistoryStorage.removeChat(itemTime)) {
          timeHistory.update((val) {
            val!.removeWhere((element) => element.time == itemTime);
          });
          update();

          log("Chat Deleted");
          await ChatHistoryStorage.saveTimeHistory(timeHistory.value);
          await initializeList();
        }
      },
    );
  }

  //selecting the chat in drawer and setting new to false and
  //initializing the selectime and previous list length with current time and selectedchat length
  Future selectedChat(String itemTime) async {
    await Future.delayed(
      Duration.zero,
      () async {
        isNew(false);
        update();

        selectedTime(itemTime);
        update();

        final chat = await ChatHistoryStorage.getChatHistory(itemTime);
        textList(chat);
        log("TextList: ${textList.value.length}");
        update();

        pLL(textList.value.length);
        log("previousList: ${pLL.value}");
        update();

        checkonBottom();

        log("textlist: ${textList.value.isEmpty}");
        log("previousList: ${pLL.value}");
      },
    );
  }

  //saving the chat whenever the user exits the app or selects drawer
  Future<void> savingSelectedUpdatedChat() async {
    await Future.delayed(
      Duration.zero,
      () async {
        log("previousList: ${pLL.value}");

        if (textList.value.isNotEmpty) {
          //check if new chat
          if (isNew.value) {
            log("New");
            await saveTimeAndChat();
          } else if (!compareTwoList(pLL.value, textList.value)) {
            // if not new chat then compare the previous selected chat length and
            // updated chat and if true store with new time and remove previous chat
            if (await ChatHistoryStorage.removeChat(selectedTime.value)) {
              log("something added");
              final value = timeHistory.value
                  .where((element) => element.time == selectedTime.value)
                  .toList();
              if (value.isNotEmpty) {
                title(formatTitle(value.first.title));
                update();
              }
              timeHistory.update((val) {
                val!.removeWhere(
                    (element) => element.time == selectedTime.value);
              });
              isNew(true);
              update();
              await saveTimeAndChat();
            }
          } else {
            log("nothing...");
          }
        }
      },
    );
  }

//used for deleting all the chats stored in the user local storage
  void deleteAllChatHistory() async {
    isLoading(true);
    update();

    //showing snackbar if the timehistory is empty
    if (timeHistory.value.isEmpty) {
      Get.snackbar("", "",
          titleText: Text(
            "No Chat History",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[800]);
      //if chat is deleted from the local storage by the function call
    } else if (await ChatHistoryStorage.deleteAllData(timeHistory.value)) {
      initializeList();
      Get.snackbar("", "",
          titleText: Text(
            "Chat Deleted",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          messageText: Text(
            "Deleted all the chat succesfully",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[800]);

      //if the chat is not deleted if some error
    } else {
      Get.snackbar("", "",
          titleText: Text(
            "Chat Not Deleted",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          messageText: Text(
            "Error while Deleting",
            style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[800]);
    }
    isLoading(false);
    update();
  }

//Used for removing api in the settings screen
  void removeApi() async {
    if (await ChatHistoryStorage.setApiKey("")) {
      await initializeKey();
    }
  }
}
