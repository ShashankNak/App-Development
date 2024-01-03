import 'package:chatbot/database/chat_storage.dart';
import 'package:chatbot/presentation/pages/chat/chat.dart';
import 'package:chatbot/presentation/pages/start/start_screen.dart';
import 'package:chatbot/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GemBOT',
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: ThemeMode.system,
      // home: const ChatScreen(timehistory: []),
      home: FutureBuilder(
        future: ChatHistoryStorage.getApiKey(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Scaffold(
                body: Text("Something Went Wrong"),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data == "") {
                  return const StartScreen();
                } else {
                  return const ChatScreen(timehistory: []);
                }
              }
              return const StartScreen();
          }
        },
      ),
    );
  }
}
