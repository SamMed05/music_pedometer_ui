import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  primaryColor: Colors.white,
  canvasColor: const Color.fromARGB(255, 51, 51, 51),
  scaffoldBackgroundColor: const Color.fromARGB(255, 34, 34, 34),
  // primaryTextTheme: Typography(platform: TargetPlatform.android).white,
  // textTheme: Typography(platform: TargetPlatform.android).white,
  // textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Color.fromARGB(255, 255, 255, 255), // Icons in the bottom navbar use this color
    onSecondary: Color.fromARGB(255, 61, 61, 61),
    surface: const Color.fromARGB(255, 34, 34, 34),
    onSurface: Colors.white,
  ),
);