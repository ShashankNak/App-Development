import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nasa_app/Theme/theme.dart';
import 'package:nasa_app/api/auth_api.dart';
import 'package:nasa_app/firebase_options.dart';
import 'package:nasa_app/screens/home_screen.dart';
import 'package:nasa_app/screens/start/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings.persistenceEnabled;

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: darkTheme,
        home: StreamBuilder(
          stream: API.auth.authStateChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                try {
                  if (snapshot.hasData && snapshot.data != null) {
                    snapshot.data!.reload();
                  }
                } catch (e) {
                  log(e.toString());
                }
                if (snapshot.data != null && snapshot.hasData) {
                  log("Auto Login!>>>>>");
                  return const HomeScreen();
                }
                return const StartScreen();
            }
          },
        ));
  }
}
