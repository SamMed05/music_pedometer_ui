import 'package:flutter/material.dart';
import 'audio_player_widget.dart';
import 'models/playlist_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          toolbarHeight: 0, // Remove empty white space
          elevation: 4,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.monitor_heart_sharp),
                // text: "Rhythm",
              ),
              Tab(
                icon: Icon(Icons.directions_walk_sharp),
                // text: "Steps",
              ),
              Tab(
                icon: Icon(Icons.bar_chart_sharp),
                // text: "Accelerometer",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded( // Without this everything is white
              child: TabBarView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "SPM vs BPM",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 23,
                              // color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "This visualization represents your current step frequency (SPM) compared to the original BPM (tempo) of the song",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              // color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage(
                                "assets/images/visualizer-placeholder.png"),
                            height: 230,
                            width: 280,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text("Second tab"),
                  ),
                  Center(
                    child: Text("Third tab"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [Consumer<PlaylistProvider>(
                builder: (context, playlistProvider, child) {
                  final mostRecentSong = playlistProvider.getMostRecentSong();
                  return mostRecentSong != null
                      ? AudioPlayerWidget()
                      : Text("No songs available. Import one from the playlist page ➡️");
                }
                ),],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SwitchListTile(
          value: true,
          title: Text(
            "Activate Sync",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 15,
              // color: Color(0xff000000),
            ),
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            "Sync music BPM to your steps",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              fontSize: 13,
              // color: Color(0xff000000),
            ),
            textAlign: TextAlign.start,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          onChanged: (value) {},
          controlAffinity: ListTileControlAffinity.trailing,
          dense: true,
          // tileColor: Theme.of(context).colorScheme.onSecondary,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveThumbColor: Theme.of(context).colorScheme.secondary,
          inactiveTrackColor: Theme.of(context).canvasColor,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          secondary: Icon(
            Icons.timer,
            // color: Color(0xff000000),
            size: 24
          ),
          selected: false,
          selectedTileColor: Color(0x42000000),
        ),
      ),
    );
  }
}
