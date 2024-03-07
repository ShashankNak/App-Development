import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.comfortaaTextTheme(),
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 246, 226, 185),
    onBackground: Colors.black,
    primary: Color.fromARGB(255, 175, 147, 76),
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    secondaryContainer: Colors.white,
    onPrimaryContainer: Color.fromARGB(210, 0, 0, 0),
    tertiary: Color.fromARGB(255, 86, 50, 17),
  ),
);

ThemeData darkTheme = ThemeData(
  textTheme: GoogleFonts.comfortaaTextTheme(),
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromRGBO(2, 22, 39, 1),
    onBackground: Colors.white,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.black,
    secondaryContainer: Color.fromARGB(255, 22, 21, 21),
    onPrimaryContainer: Colors.white60,
    tertiary: Color.fromARGB(255, 23, 16, 46),
  ),
);
