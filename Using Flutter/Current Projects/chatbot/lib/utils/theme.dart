import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  textTheme: GoogleFonts.inconsolataTextTheme(),
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(249, 24, 24, 24),
    primary: Color.fromARGB(248, 24, 28, 37),
    onBackground: Colors.white,
    onPrimary: Colors.white,
    secondary: Color.fromARGB(248, 44, 51, 67),
    onSecondary: Colors.white,
  ),
);
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: GoogleFonts.inconsolataTextTheme(),
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(248, 237, 251, 255),
    primary: Color.fromARGB(248, 200, 243, 255),
    onBackground: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(248, 199, 216, 255),
    onSecondary: Colors.black,
  ),
);

TextTheme customTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

ColorScheme customColorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}
