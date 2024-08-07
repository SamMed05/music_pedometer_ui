// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import 'playlist.dart';
// import 'options.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Music Pedometer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'playlist.dart';
import 'options.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Pedometer',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // https://api.flutter.dev/flutter/material/PageTransitionsBuilder-class.html
            // https://api.flutter.dev/flutter/material/PageTransitionsTheme-class.html
            // TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            // TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            // TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            // TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            // TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            // TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            // TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/playlist': (context) => Playlist(),
        '/options': (context) => Options(),
      },
    );
  }
}