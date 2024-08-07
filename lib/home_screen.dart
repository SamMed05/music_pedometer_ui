import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'dart:async'; // https://api.flutter.dev/flutter/dart-async/dart-async-library.html

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}); // unique identifier that is attached to widgets to help Flutter distinguish between different widgets and track changes efficiently when the UI rebuilds
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
        currentIndex: 0,
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
                image: AssetImage("assets/images/placeholder1.png"),
                height: 200,
                width: 240,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: AudioPlayerWidget(
              // url: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
              url: Uri.parse("asset:///assets/audio-example.mp3").toString(),
              iconColor: Color(0xff000000),
              activeTrackColor: Color(0xff525252),
              inactiveTrackColor: Color(0xffe0e0e0),
              thumbColor: Color(0xff000000),
              iconSize: 42,
            ),
          ),
          SwitchListTile(
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
            tileColor: Color(0x1fffffff),
            activeColor: Color(0xff000000),
            activeTrackColor: Color(0xff9d9d9d),
            controlAffinity: ListTileControlAffinity.trailing,
            dense: true,
            inactiveThumbColor: Color(0xff9e9e9e),
            inactiveTrackColor: Color(0xffe0e0e0),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            secondary: Icon(Icons.timer, color: Color(0xff212435), size: 24),
            selected: false,
            selectedTileColor: Color(0x42000000),
          ),
        ],
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


  late StreamSubscription<Duration?> _positionSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();



    _positionSubscription = _audioPlayer.positionStream.listen((duration) {
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

    // setState(() {
    //   _isPlaying = !_isPlaying;
    // });
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