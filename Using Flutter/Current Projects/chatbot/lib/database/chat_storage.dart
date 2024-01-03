import 'dart:convert';
import 'dart:developer';
import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/model/time_model.dart';
import 'package:chatbot/model/voice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryStorage {
  static const String _chatkey = 'chatHistory';
  static const String _timekey = 'timeHistory';
  static const String _apikey = 'apiKey';
  static const String _voicekey = 'voiceKey';

  //SAVING TIMEHISTORY LIST OF TIME
  static Future<void> saveTimeHistory(List<TimeModel> timeHistory) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<Map<String, dynamic>> timeList =
          timeHistory.map((time) => time.toMap()).toList();
      log("time Storing.......");
      await prefs
          .setStringList(_timekey, timeList.map((e) => jsonEncode(e)).toList())
          .then((value) => log("time Stored"));
    } catch (e) {
      log("error while storing time: ${e.toString()}");
    }
  }

  //GETTING TIMEHISTORY
  static Future<List<TimeModel>> getTimeHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final timeList = prefs.getStringList(_timekey) ?? [];

      timeList.isEmpty ? log("Empty time...") : log("Getting time.......");

      return timeList
          .map((time) => TimeModel.fromMap(jsonDecode(time)))
          .toList();
    } catch (e) {
      log("error while getting time: ${e.toString()}");
      return [];
    }
  }

  //REMOVE SPECIFIC CHAT BASED ON TIME
  static Future<bool> removeChat(String time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove("$_chatkey/$time");
    } catch (e) {
      log("error in removing chat");
      return false;
    }
  }

  // Save the chat history to local storage
  static Future<void> saveChatHistory(
      List<ChatModel> chatHistory, String time) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<Map<String, dynamic>> chatList =
          chatHistory.map((chat) => chat.toMap()).toList();
      log("chat Storing.......");
      await prefs.setStringList(
          "$_chatkey/$time", chatList.map((e) => jsonEncode(e)).toList());
      log("chat Stored");
    } catch (e) {
      log("error while storing chat: ${e.toString()}");
    }
  }

  // Retrieve the chat history from local storage
  static Future<List<ChatModel>> getChatHistory(String time) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final chatList = prefs.getStringList("$_chatkey/$time") ?? [];
      chatList.isEmpty ? log("Empty Chat...") : log("Getting Chat.......");

      return chatList
          .map((chat) => ChatModel.fromMap(jsonDecode(chat)))
          .toList();
    } catch (e) {
      log("error while getting chat: ${e.toString()}");
      return [];
    }
  }

  //CLEARING THE LOCAL STORAGE JUST FOR DEBUGGING
  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();

    return await prefs.clear();
  }

  //GET THE SAVED API
  static Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString(_apikey) ?? "";
    } catch (e) {
      return "";
    }
  }

  //SAVE THE API
  static Future<bool> setApiKey(String api) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_apikey, api);
    } catch (e) {
      return false;
    }
  }

  //DELETE ALL THE TIME HISTORY AND THE CHATS
  static Future<bool> deleteAllData(List<TimeModel> timeHistory) async {
    try {
      if (timeHistory.isEmpty) {
        return true;
      }
      final prefs = await SharedPreferences.getInstance();
      for (var x in timeHistory) {
        if (await prefs.remove("$_chatkey/${x.time}")) {
          continue;
        } else {
          return false;
        }
      }
      return await prefs.remove(_timekey);
    } catch (e) {
      return false;
    }
  }

  //GET THE CURRENT VOICE OF THE MODEL
  static Future<Voice> getVoice() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final value = prefs.getString(_voicekey);
      if (value != null) {
        final voice = Voice.fromString(value);
        return voice;
      } else {
        throw "";
      }
    } catch (e) {
      return Voice(name: "en-US-Language", locale: "en-US");
    }
  }

  //SAVE THE VOICE OF THE MODEL
  static Future<bool> setVoice(Voice v) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = await prefs.setString(_voicekey, v.toString());
      return value;
    } catch (e) {
      return false;
    }
  }
}
