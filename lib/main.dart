import 'package:flutter/material.dart';
import 'package:music_pedometer_ui/models/playlist_provider.dart';
import 'navigation_menu.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'themes/theme_provider.dart';
import 'themes/light_mode.dart';
import 'themes/dark_mode.dart';

Future<void> main() async {
  //  Add just_audio_background initialization
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // runApp(MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Pedometer',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: NavigationMenu(),
    );
  }
}
