import 'package:flutter/material.dart';
// import 'custom_app_bar.dart';
// import 'common_drawer.dart';

class Playlist extends StatefulWidget {
  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool onlyCompatible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      // appBar: CustomAppBar(title: "Playlist"),
      // drawer: CommonDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: Text(
              "Only compatible",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
            subtitle: Text(
              "Recommend songs with tempo matching your current SPM",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                fontSize: 11,
                color: Color(0xff000000),
              ),
            ),
            trailing: Switch(
              value: onlyCompatible,
              onChanged: (value) {
                setState(() {
                  onlyCompatible = value;
                });
              },
              // activeColor: Color(0xff000000),
              // activeTrackColor: Color(0xff9d9d9d),
              activeColor: Theme.of(context).colorScheme.primary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).canvasColor,
            ),
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

class SongItem extends StatefulWidget {
  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  bool isChecked = false;

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
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                activeColor: Color(0xff000000),
                autofocus: false,
                checkColor: Color(0xffffffff),
                hoverColor: Color(0x42000000),
                splashRadius: 20,
                value: isChecked,
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0x1f000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(100),
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
