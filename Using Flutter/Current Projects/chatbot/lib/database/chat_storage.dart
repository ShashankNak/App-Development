import 'dart:convert';
import 'dart:developer';
import 'package:chatbot/model/chat_model.dart';
import 'package:chatbot/model/time_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryStorage {
  static const String _chatkey = 'chatHistory';
  static const String _timekey = 'timeHistory';
  static const String _isNew = 'isNew';

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

  static Future<bool> getisNew() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isNew) ?? true;
  }

  // Setter for the boolean value
  static Future<void> setisNew(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isNew, value);
  }

  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();

    return await prefs.clear();
  }
}
