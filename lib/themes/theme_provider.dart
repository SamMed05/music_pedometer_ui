import 'package:flutter/material.dart';
import '/themes/dark_mode.dart';
import '/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Thanks https://youtu.be/Zr4j6W7nmpg
class ThemeProvider extends ChangeNotifier {
  // Initially light mode
  ThemeData _themeData = lightMode;

  
  // Load the theme from shared preferences
  Future<void> _loadThemeFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to light mode
    themeData = isDarkMode ? darkMode : lightMode;
  }
  // Save the theme to shared preferences
  Future<void> _saveThemeToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Get theme
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  // Set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemeToStorage(); // Save the theme after setting

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
  
  // Call _loadThemeFromStorage() in the constructor
  ThemeProvider() {
    _loadThemeFromStorage();
  }
}