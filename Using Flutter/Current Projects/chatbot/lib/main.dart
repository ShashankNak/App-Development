// import 'dart:developer';

// import 'package:chatbot/database/chat_storage.dart';

import 'package:chatbot/database/chat_storage.dart';
// import 'package:chatbot/database/hive_storage.dart';
import 'package:chatbot/presentation/pages/chat.dart';
// import 'package:chatbot/model/time_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: 'AIzaSyCnDQEaDwx9eZ46pww3Mqgd8eTq_xowRyg');
  // await HiveStorage.initialize().then(
  //   (value) => log("initalized Hive----------->"),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.white,
          selectionColor: Color.fromARGB(
              47, 255, 255, 255), // Text selection highlight color
          cursorColor: Colors.white, // Cursor handle color
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(timehistory: []),
    );
  }
}
