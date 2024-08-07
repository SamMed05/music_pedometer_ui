import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  List<BottomNavigationBarItem> bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: "Playlist"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Options")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Music Pedometer",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            color: Color(0xffffffff),
          ),
        ),
        leading: Icon(
          Icons.menu,
          color: Color(0xffffffff),
          size: 24,
        ),
        actions: [
          Icon(Icons.account_circle, color: Color(0xffffffff), size: 24),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        backgroundColor: Color(0xffe0e0e0),
        currentIndex: 2,
        elevation: 10,
        iconSize: 24,
        selectedItemColor: Color(0xff000000),
        unselectedItemColor: Color(0xff525252),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        // onTap: (value) {},
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/playlist');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/options');
              break;
          }
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(0),
              shrinkWrap: false,
              physics: ScrollPhysics(),
              children: [
                SwitchListTile(
                  value: false,
                  title: Text(
                    "Dark theme",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 13,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  onChanged: (value) {},
                  tileColor: Color(0x1fffffff),
                  activeColor: Color(0xff000000),
                  activeTrackColor: Color(0xff9d9d9d),
                  controlAffinity: ListTileControlAffinity.trailing,
                  dense: true,
                  inactiveThumbColor: Color(0xff9e9e9e),
                  inactiveTrackColor: Color(0xffe0e0e0),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
