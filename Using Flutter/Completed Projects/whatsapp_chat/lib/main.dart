import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_chat/screens/auth.dart';
// import 'package:whatsapp_chat/screens/home.dart';
import 'package:whatsapp_chat/screens/splash.dart';
import 'package:whatsapp_chat/screens/verify.dart';
// import 'package:whatsapp_chat/screens/verify.dart';

import 'firebase_options.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 152, 171),
  secondary: const Color.fromARGB(255, 0, 0, 0),
  background: const Color.fromARGB(255, 74, 128, 101),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    titleSmall: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Chat',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return const EmailVerifyScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
