import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatbot/model/voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../model/chat_model.dart';

const greeting =
    "Hii dear, we extend a warm and heartfelt welcome to you! It's a pleasure to have you join our vibrant community, and we look forward to sharing exciting experiences and meaningful moments together. If you have any questions or need assistance, feel free to reach out. Cheers to new beginnings!";

final apiUrl = Uri.parse("https://makersuite.google.com/");

String timeGetter(String time, BuildContext context) {
  final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  final dayTime = TimeOfDay.fromDateTime(date).format(context);
  return dayTime;
}

String getLastActiveTime(
    {required BuildContext context, required String lastActive}) {
  final i = int.tryParse(lastActive) ?? -1;
  if (i == -1) {
    return "Last Active Time Not Available";
  }

  final time = DateTime.fromMillisecondsSinceEpoch(i);
  // log(time.toString());
  final now = DateTime.now();

  final formattedTime = TimeOfDay.fromDateTime(time).format(context);
  if (now.day == time.day && now.month == time.month && now.year == time.year) {
    return "Last Seen today at $formattedTime";
  }

  if ((now.difference(time).inHours / 24).round() == 1) {
    return "Last Seen Yesterday at $formattedTime";
  }

  if (now.year - time.year > 1) {
    return "Last seen on ${time.day} ${getMonth(time)},${time.year} on $formattedTime";
  }

  return "Last seen on ${time.day} ${getMonth(time)} on $formattedTime";
}

String dateGetter(String time1) {
  final time = DateTime.fromMillisecondsSinceEpoch(int.parse(time1));

  final now = DateTime.now();

  if (now.day == time.day && now.month == time.month && now.year == time.year) {
    return "Today";
  }
  if (now.month == time.month &&
      now.year == time.year &&
      now.day - time.day == 1) {
    return "Yesterday";
  }

  if (now.year - time.year > 1) {
    final date =
        "${time.day.toString()} ${getMonth(time)},${time.year.toString()}";
    return date;
  }
  return "${time.day.toString()} ${getMonth(time)}";
}

String getMonth(DateTime data) {
  switch (data.month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
  }
  return "NA";
}

List<Content> convertChat(List<ChatModel> chatmodel) {
  final chatM = chatmodel.reversed.toList();
  Content? data;
  List<Content> lst = [];
  log(chatM.length.toString());
  for (ChatModel c in chatM) {
    if (c.text == "") {
      continue;
    }
    data = Content(parts: [
      Parts(
        text: c.text,
      )
    ], role: c.isMe ? "user" : "model");
    lst.add(data);

    log("Message : ${c.text.length},index: ${chatM.indexOf(c)}");
  }
  return lst;
}

bool compareTwoList(int prev, List<ChatModel> cur) {
  log("cur: ${cur.length}");
  log("prev: $prev");
  log("Comparing: ${prev == cur.length}");
  return prev == cur.length;
}

String convertChatText(List<ChatModel> chatmodel) {
  final chatM = chatmodel.reversed.toList();
  Content? data;
  List<Content> lst = [];
  log(chatM.length.toString());
  for (ChatModel c in chatM) {
    if (c.text == "") {
      continue;
    }
    data = Content(parts: [
      Parts(
        text: c.text,
      )
    ], role: c.isMe ? "user" : "model");
    lst.add(data);
  }

  final v = {
    'contents': lst.map((e) => e.toJson()).toList(),
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
  return jsonEncode(v);
}

String convertChatImage(ChatModel chatmodel) {
  final v = {
    'contents': [
      {
        "parts": [
          {"text": chatmodel.text},
          {
            "inline_data": {
              "mime_type": "image/jpeg",
              "data": base64Encode(File(chatmodel.img).readAsBytesSync())
            }
          }
        ]
      }
    ],
    'generationConfig': {
      'temperature': 0.4,
      'topK': 32,
      'topP': 1,
      'maxOutputTokens': 4096,
      'stopSequences': []
    },
    'safetySettings': []
  };

  return jsonEncode(v);
}

String formatTitle(String x) {
  x = x.replaceAll(RegExp(r'^\*+|\*+'), '');
  return x;
}

compareToStringVoice(Voice s1, Voice s2) {
  return s1.name.compareTo(s2.name) == 0 && s2.locale.compareTo(s2.locale) == 0;
}
