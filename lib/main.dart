import 'package:flutter/material.dart';
import 'navigation_menu.dart';
import 'package:just_audio_background/just_audio_background.dart';

// void main() {
//   runApp(MyApp());
// }

//  Add just_audio_background  initialization
Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Pedometer',
      theme: ThemeData(
        primaryColor: Colors.black,
        canvasColor: Color.fromARGB(255, 231, 231, 231),  // Background color for material components
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black, // Primary color
          onPrimary: Colors.white, // Text color on primary
          secondary: Colors.grey, // Secondary color
          onSecondary: Colors.black, // Text color on secondary
          surface: Colors.white, // Background color
          onSurface: Colors.black, // Text color on surface
          error: Colors.red, // Error color
          onError: Colors.white, // Text color on error
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: NavigationMenu(),
    );
  }
}
