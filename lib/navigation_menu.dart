import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation_controller.dart';
import 'custom_app_bar.dart';
import 'common_drawer.dart';

class NavigationMenu extends StatefulWidget {
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  // Create a PageController
  final PageController _pageController = PageController();

  // Thanks https://youtu.be/qdO1hwg2HY8
  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: (_getTitle(controller.selectedIndex.value)),
        ),
        drawer: CommonDrawer(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // Update the selected index when the page changes
            controller.selectedIndex.value = index;
          },
          children: controller.screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            // Update the PageView and BottomNavigationBar when an item is tapped
            controller.selectedIndex.value = index;
            _pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.home_filled,
                    size: 29,
                  ),
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.format_list_bulleted_sharp,
                    size: 29,
                  ),
                ),
                label: "Playlist"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.settings,
                    size: 29,
                  ),
                ),
                label: "Options"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the PageController when the widget is disposed
    _pageController.dispose();
    super.dispose();
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
