import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  primaryColor: Colors.black,
  canvasColor: Color.fromARGB(255, 231, 231, 231),
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey, // Icons in the bottom navbar use this color
    onSecondary: Color.fromARGB(255, 231, 231, 231),
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);