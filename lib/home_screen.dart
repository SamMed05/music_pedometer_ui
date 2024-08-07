import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';

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
          title: const Text('TabBar Sample'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
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
                iconColor: Color(0xff000000),
                activeTrackColor: Color(0xff525252),
                inactiveTrackColor: Color(0xffe0e0e0),
                thumbColor: Color(0xff000000),
                iconSize: 42,
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
                fontSize: 11,
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

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  final Color iconColor;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color thumbColor;
  final double iconSize;

  AudioPlayerWidget({
    required this.url,
    required this.iconColor,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.thumbColor,
    required this.iconSize,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  // late AudioPlayer audioPlayer;
  AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // late StreamSubscription<Duration?> positionSubscription;

  @override
  void initState() {
    // super.initState();
    // audioPlayer = AudioPlayer();

    // positionSubscription = audioPlayer.positionStream.listen((duration) {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.setUrl(widget.url);
      await audioPlayer.play();

      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  // TODO Can't do this now, since songResult is in playlist.dart
  // void playAudio() {
  //   if (songResult != null) {
  //     audioPlayer.play(DeviceFileSource(songResult!.files.single.path!));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.iconColor,
              size: widget.iconSize,
            ),
            onPressed: _togglePlayback,
          ),
          Expanded(
            child: StreamBuilder<Duration?>(
              stream: audioPlayer.positionStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return Slider(
                  value: duration.inSeconds.toDouble(),
                  min: 0,
                  max: (audioPlayer.duration?.inSeconds ?? 0).toDouble(),
                  activeColor: widget.activeTrackColor,
                  inactiveColor: widget.inactiveTrackColor,
                  thumbColor: widget.thumbColor,
                  onChanged: (value) {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
