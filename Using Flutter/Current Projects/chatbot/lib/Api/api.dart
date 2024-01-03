import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatbot/model/chat_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:http/http.dart' as http;

import '../presentation/widgets/helper/consts.dart';

class Api {
  //GET THE RESPONSE FROM GEMINI
  static Future<String> getGeminiResponse(
      List<ChatModel> textList, ChatModel chatModel) async {
    try {
      final gemini = Gemini.instance;
      final value = chatModel.img == ""
          ? await gemini.chat(convertChat(textList),
              modelName: "models/gemini-pro")
          : await gemini.textAndImage(
              text: chatModel.text,
              image: File(chatModel.img).readAsBytesSync(),
              modelName: "models/gemini-pro-vision");
      if (value != null && value.output != null) {
        return value.output!;
      } else {
        throw "Somthing went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  //GET THE TITLE OF THE CHAT
  static Future<String> getAgenda(List<ChatModel> textList) async {
    try {
      final gemini = Gemini.instance;
      final value = await gemini.chat(convertChat(textList),
          modelName: "models/gemini-pro");
      if (value != null && value.output != null) {
        return value.output!;
      } else {
        throw "Somthing went wrong";
      }
    } catch (e) {
      return "";
    }
  }

  //CHECKING FOR THE VALID API
  static Future<bool> checkApiKey(String apikey) async {
    var client = http.Client();
    Uri url;

    try {
      final requestHeaders = {
        'Content-Type': 'application/json',
      };

      String requestBody = "";
      if (apikey != "") {
        url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apikey');
        final v = {
          'contents': [
            {
              "parts": [
                {"text": "What is Google?"}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.9,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2048,
            'stopSequences': []
          },
          'safetySettings': []
        };
        log(jsonEncode(v));
        requestBody = jsonEncode(v);

        final response =
            await client.post(url, headers: requestHeaders, body: requestBody);
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

//version of http request and response from api with request header and body
  // static Future<String> getApiResponse(
  //     List<ChatModel> textList, ChatModel chatModel) async {
  //   var client = http.Client();
  //   Uri url;

  //   try {
  //     final requestHeaders = {
  //       'Content-Type': 'application/json',
  //     };

  //     String requestBody = "";

  //     if (chatModel.img != "") {
  //       url = Uri.parse(
  //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$apikey');
  //       requestBody = convertChatImage(chatModel);
  //     } else {
  //       url = Uri.parse(
  //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apikey');
  //       requestBody = convertChatText(textList);
  //     }
  //     log(requestBody);

  //     final response =
  //         await client.post(url, headers: requestHeaders, body: requestBody);

  //     if (response.statusCode == 200) {
  //       // Decode the response body.
  //       final responseData = jsonDecode(response.body);

  //       // Print the generated text.
  //       final output = responseData['candidates'][0]['content']['parts'][0]
  //               ['text']
  //           .toString();
  //       log("message: ${output.toString()}");
  //       return output;
  //     } else {
  //       // If the status code is not 200, throw an error.
  //       throw HttpException(
  //           'Failed to generate text. Status code: ${response.statusCode}');
  //     }
  //   } on HttpException catch (e) {
  //     log(e.message);
  //     return e.message.toString();
  //   }
  // }
}
