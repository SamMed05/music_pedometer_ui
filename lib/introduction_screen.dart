import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'navigation_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    // Save initScreen to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('initScreen', 1);

    // Navigate to the main app
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => NavigationMenu()),
    );
  }

  Widget _buildImage(String assetName, [double width = 180]) {
    return SvgPicture.asset(
      'assets/$assetName',
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 17, color: Colors.white);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 35, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.black,
      allowImplicitScrolling: true,
      autoScrollDuration: 5000,
      infiniteAutoScroll: true,
      // globalHeader: Align(
      //   alignment: Alignment.topRight,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 16),
      //       child: _buildImage('images/app-logo.png', 100),
      //     ),
      //   ),
      // ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to BeatStride",
          body:
              "Discover a new way to sync your steps with your music. BeatStride adjusts the playback speed automatically, letting your pace control the rhythm.",
          image: _buildImage('images/svg/app-logo.svg', 220), 
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Visualize your rhythm",
          body:
              "See in real-time how your steps influence the music, as the app dynamically matches your movement with the rhythm.",
          image: _buildImage('images/svg/music-rhythm.svg', 160),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Customize your experience",
          body:
              "Choose your favorite tracks in the playlist and adjust the system parameters in the options, tailoring BeatStride to your own preferences.",
          image: _buildImage('images/svg/sliders.svg', 150),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back, color: Colors.white),
      skip: const Text('Skip',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      next: const Icon(Icons.arrow_forward, color: Colors.white),
      done: const Text('Done',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.white,
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: Colors.white,
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}