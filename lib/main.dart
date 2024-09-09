import 'package:flutter/material.dart';
import 'models/playlist_provider.dart';
import 'navigation_menu.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'themes/theme_provider.dart';
import 'step_detection_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'introduction_screen.dart';

int? initScreen;

Future<void> main() async {
  // Add just_audio_background initialization
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // Initialize shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get the value of the intro screen variable
  initScreen = prefs.getInt('initScreen') ?? 0;

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
          // home: NavigationMenu(),
          // home: const OnBoardingPage(), // Set the home screen to the intro screen
          // If initScreen is 0 (first launch), show the introduction screen
          initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home', // Set initial route based on initScreen (thanks https://youtu.be/Vu301Ra3RhI)
          routes: {
            'home': (context) => NavigationMenu(), 
            'onboard': (context) => OnBoardingPage(), 
          },
        );
      },
    );
  }
}
