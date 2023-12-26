import 'dart:developer';
import 'dart:io';

import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/presentation/widgets/consts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Api {
  static Future<String> getResponse(
      List<ChatModel> textList, ChatModel chatModel) async {
    try {
      final gemini = Gemini.instance;
      final value = chatModel.img == ""
          ? await gemini.chat(convertChat(textList))
          : await gemini.textAndImage(
              text: chatModel.text,
              image: File(chatModel.img).readAsBytesSync());
      log("Gemini Generated");
      return value!.output!;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> getAgenda(String listString) async {
    try {
      final gemini = Gemini.instance;
      final value =
          await gemini.text("What is the agenda of the chat:\n $listString");

      log("Gemini Generated Agenda");
      return value!.output!;
    } catch (e) {
      return e.toString();
    }
  }
}
