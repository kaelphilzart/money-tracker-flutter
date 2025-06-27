import 'package:flutter/material.dart';

class AppColorsLight {
  static const primary = Color(0xFF00C853); // green elegant
  static const secondary = Color(0xFF424242); // dark grey
  static const background = Color(0xFFFFFFFF); // white
  static const surface = Color(0xFFF5F5F5);
  static const error = Colors.red;
  static const onPrimary = Colors.white;
  static const onSecondary = Colors.white;
  static const onBackground = Colors.black;
  static const onSurface = Colors.black;
  static const darkGreen = LinearGradient(
    colors: [
      Color.fromARGB(255, 1, 130, 55),
      Color.fromARGB(255, 0, 66, 34),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppColorsDark {
  static const primary = Color(0xFF00E676); // brighter green
  static const secondary = Color(0xFF212121);
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const error = Colors.redAccent;
  static const onPrimary = Colors.black;
  static const onSecondary = Colors.white;
  static const onBackground = Colors.white;
  static const onSurface = Colors.white;
}
