import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
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
        currentIndex: 1,
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
          SwitchListTile(
            value: true,
            title: Text(
              "Only compatible",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 15,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            subtitle: Text(
              "Recommend songs with tempo matching your current SPM",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                fontSize: 11,
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
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            secondary: Icon(Icons.filter_alt_outlined,
                color: Color(0xff212435), size: 24),
            selected: false,
            selectedTileColor: Color(0x42000000),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: 10, // Replace with the actual number of items
              itemBuilder: (context, index) {
                return SongItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SongItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Checkbox(
                onChanged: (value) {},
                activeColor: Color(0xff000000),
                autofocus: false,
                checkColor: Color(0xffffffff),
                hoverColor: Color(0x42000000),
                splashRadius: 20,
                value: true,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(2),
                width: 180,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0x1f000000),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(
                      image: AssetImage("assets/images/music-icon.png"),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Counting Stars",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 13,
                                color: Color(0xff000000),
                              ),
                            ),
                            Text(
                              "OneRepublic",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              padding: EdgeInsets.all(3),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0x1f000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: Text(
                "122",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
