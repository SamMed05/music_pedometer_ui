import 'package:flutter/material.dart';
import '/themes/dark_mode.dart';
import '/themes/light_mode.dart';

// Thanks https://youtu.be/Zr4j6W7nmpg
class ThemeProvider extends ChangeNotifier {
  // Initially light mode
  ThemeData _themeData = lightMode;

  // Get theme
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  // Set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // Update UI
    notifyListeners();
  }

  // Toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}