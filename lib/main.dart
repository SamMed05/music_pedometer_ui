import 'package:flutter/material.dart';
import 'models/playlist_provider.dart';
import 'navigation_menu.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'themes/theme_provider.dart';
import 'step_detection_provider.dart';

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
        ChangeNotifierProvider(create: (context) => StepDetectionProvider(Provider.of<PlaylistProvider>(context, listen: false))),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StepDetectionProvider>( // Adding this Consumer is necessary to make the StepDetectionProvider always active and listening for accelerometer data on app initialization (without this the step detection only starts when changing tab or going to the options page)
      builder: (context, stepDetectionProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music Pedometer',
          theme: Provider.of<ThemeProvider>(context).themeData,
          home: NavigationMenu(),
        );
      },
    );
  }
}
