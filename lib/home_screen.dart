import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_player_widget.dart';
// import 'playlist.dart'; // To play the song loaded from the playlist

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double playbackRate = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // title: Text('TabBar'),
          toolbarHeight: 0, // Remove empty white space
          elevation: 4,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.monitor_heart_sharp),
                text: "Rhythm",
              ),
              Tab(
                icon: Icon(Icons.directions_walk_sharp),
                text: "Steps",
              ),
              Tab(
                icon: Icon(Icons.bar_chart_sharp),
                text: "Movement data",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView( // Without this everything is white
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "SPM vs BPM",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 25,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "This visualization represents your current step frequency (SPM) compared to the original BPM (tempo) of the song.",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              color: Color(0xff000000),
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
                            height: 250,
                            width: 300,
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
              // TODO It's maybe better to implement the audio fetching outside in a separate function
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: AudioPlayerWidget(
                url: Uri.parse("asset:///assets/audio-example.mp3").toString(),
                // iconColor: Color(0xff000000),
                // activeTrackColor: Color(0xff000000),
                // inactiveTrackColor: Color(0xffe0e0e0),
                // thumbColor: Color(0xff000000),
                // iconSize: 42,
                songTitle: "Song Title",
                songArtist: "Song Artist",
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SwitchListTile(
            value: true,
            title: Text(
              "Activate Sync",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 15,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            subtitle: Text(
              "Synch music BPM to your steps",
              style: TextStyle(
                fontWeight: FontWeight.w300,
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
            controlAffinity: ListTileControlAffinity.trailing,
            dense: true,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).canvasColor,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            secondary: Icon(Icons.timer, color: Color(0xff000000), size: 24),
            selected: false,
            selectedTileColor: Color(0x42000000),
          ),
        ),
      ),
    );
  }
}
