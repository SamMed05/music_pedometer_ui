import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'playlist.dart';
import 'options.dart';

// https://pub.dev/packages/get/example
class NavigationController extends GetxController {
  // Observable integer to keep track of the currently selected index
  // selectedIndex is wrapped with `.obs`, making it reactive without needing manual calls to setState
  final RxInt selectedIndex = 0.obs;

  // List of screens to be used in the navigation
  final List<Widget> screens = [
    HomeScreen(),
    Playlist(),
    Options(),
  ];
}