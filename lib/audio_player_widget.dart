import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  // final Color iconColor;
  // final Color activeTrackColor;
  // final Color inactiveTrackColor;
  // final Color thumbColor;
  // final double iconSize;
  final String songTitle;
  final String songArtist;

  AudioPlayerWidget({
    required this.url,
    // required this.iconColor,
    // required this.activeTrackColor,
    // required this.inactiveTrackColor,
    // required this.thumbColor,
    // required this.iconSize,
    required this.songTitle,
    required this.songArtist,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  // AudioPlayer audioPlayer = AudioPlayer();
  late AudioPlayer audioPlayer;
  bool _isPlaying = false;
  bool _isLooping = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // @override
  // void initState() {
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    // Set initial loop mode
    audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);

    audioPlayer.positionStream.listen((duration) {
      if (mounted) {
        // Check the "mounted" property of this object before calling setState() to ensure the object is still in the tree
        setState(() {
          this.duration = duration ?? Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // void _togglePlayback()  {
  //   if (_isPlaying) {
  //      audioPlayer.pause();
  //   } else {
  //      audioPlayer.setUrl(widget.url);
  //      audioPlayer.play();

  //     setState(() {
  //       _isPlaying = !_isPlaying;
  //     });
  //   }
  // }

  void _togglePlayback()  {
    if (_isPlaying) {
       audioPlayer.pause();
    } else {
       audioPlayer.setUrl(widget.url);
       audioPlayer.play();
    }

    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  // void _toggleLoopMode()  {
  //   _isLooping = !_isLooping;
  //    audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);

  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Add other icons here when implementing previous/next song, loop and shuffle features
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              // color: Theme.of(context).colorScheme.primary,
              // Rounded corners
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 0),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow_sharp,
                  // color: widget.iconColor,
                  // size: widget.iconSize,
                  size: 42,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: _togglePlayback,
              ),
            ),
          ],
        ),
        Container(
          // padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: StreamBuilder<Duration?>(
                      stream: audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return Column(
                          children: [
                            Slider(
                              value: duration.inSeconds.toDouble(),
                              min: 0,
                              max: (audioPlayer.duration?.inSeconds ?? 0).toDouble(),
                              // activeColor: widget.activeTrackColor,
                              // inactiveColor: widget.inactiveTrackColor,
                              // thumbColor: widget.thumbColor,
                              activeColor: Color(0xff000000),
                              inactiveColor: Color(0xffe0e0e0),
                              thumbColor: Color(0xff000000),
                              onChanged: (value)  {
                                 audioPlayer.seek(Duration(seconds: value.toInt()));
                              },
                            ),
                            // SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Thanks https://youtu.be/MB3YGQ-O1lk
                                Text(formatTime(audioPlayer.position)),
                                Text(
                                  // '$widget.songTitle',
                                  widget.songTitle,
                                ),
                                Text(
                                  ' - ',
                                ),
                                Text(
                                  // '$widget.songArtist',
                                  widget.songArtist,
                                ),
                                Text(formatTime(duration)),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  ),
                  // Add here the step count
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
