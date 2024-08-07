import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'custom_app_bar.dart';
// import 'common_drawer.dart';
import 'dart:async';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffffffff),
      // appBar: CustomAppBar(title: "Playlist"),
      // drawer: CommonDrawer(),
      body: Column(
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
                  fontSize: 17,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "This visualization represents your current step frequency (SPM) compared to the original BPM (tempo) of the song.",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                  fontSize: 11,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/images/visualizer-placeholder.png"),
                height: 300,
                width: 360,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
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
          // tileColor: Color(0x1fffffff),
          // activeColor: Color(0xff000000),
          // activeTrackColor: Color(0xff9d9d9d),
          controlAffinity: ListTileControlAffinity.trailing,
          dense: true,
          // inactiveThumbColor: Color(0xff9e9e9e),
          // inactiveTrackColor: Color(0xffe0e0e0),
          // tileColor: Color(0x1fffffff),
          activeColor: Theme.of(context).colorScheme.primary,
          activeTrackColor: Theme.of(context).colorScheme.secondary,
          inactiveThumbColor: Theme.of(context).colorScheme.secondary,
          inactiveTrackColor: Theme.of(context).canvasColor,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          secondary: Icon(Icons.timer, color: Color(0xff000000), size: 24),
          selected: false,
          selectedTileColor: Color(0x42000000),
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
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  late StreamSubscription<Duration?> positionSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    positionSubscription = _audioPlayer.positionStream.listen((duration) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setUrl(widget.url);
      await _audioPlayer.play();

      if (mounted) {
        setState(() {
          _isPlaying = !_isPlaying;
        });
      }
    }
  }

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
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return Slider(
                  value: duration.inSeconds.toDouble(),
                  min: 0,
                  max: (_audioPlayer.duration?.inSeconds ?? 0).toDouble(),
                  activeColor: widget.activeTrackColor,
                  inactiveColor: widget.inactiveTrackColor,
                  thumbColor: widget.thumbColor,
                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
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
