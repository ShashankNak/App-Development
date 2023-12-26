import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../model/chat_model.dart';

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
