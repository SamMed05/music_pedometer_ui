import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation_controller.dart';
import 'custom_app_bar.dart';
import 'common_drawer.dart';

// Thanks https://youtu.be/qdO1hwg2HY8
class NavigationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: (_getTitle(controller.selectedIndex.value)),
        ),
        drawer: CommonDrawer(),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Playlist"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Options"),
          ],
        ),
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Playlist";
      case 2:
        return "Options";
      default:
        return "Music Pedometer";
    }
  }
}