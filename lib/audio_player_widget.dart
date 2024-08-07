import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  // final Color iconColor;
  // final Color activeTrackColor;
  // final Color inactiveTrackColor;
  // final Color thumbColor;
  // final double iconSize;
  final String songName;
  final String songArtist;

  AudioPlayerWidget({
    required this.url,
    // required this.iconColor,
    // required this.activeTrackColor,
    // required this.inactiveTrackColor,
    // required this.thumbColor,
    // required this.iconSize,
    required this.songName,
    required this.songArtist,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  // AudioPlayer audioPlayer = AudioPlayer();
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLooping = false;
  double _playbackRate = 1.0;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to player state changes
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing != _isPlaying) {
        setState(() {
          _isPlaying = playerState.playing;
        });
      }
    });

    // Listen for duration changes
    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    // Listen for position changes
    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
          position = newPosition;
        });
    });

    // Handle audio completion
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            audioPlayer.seek(Duration.zero);
            audioPlayer.pause();
          });
      }
    });
    
    // // Listen for playback rate changes
    // audioPlayer.playbackRateStream.listen((newRate) { // It doesn't exist
    //   setState(() {
    //     _playbackRate = newRate;
    //   });
    // });

    // Set the audio source with the MediaItem tag
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.url),
        tag: MediaItem(
          id: '1',  // Assign a unique ID for each media item
          album: 'Album name', // TODO Replace with album name
          title: widget.songName,
          artist: widget.songArtist,
          artUri: Uri.parse('asset:///assets/images/music-icon.png'), // TODO Replace with album art URL
        ),
      ),
    );

    // Set initial loop mode
    // audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
  }

  // Not disposing the audio player allows the music to be played in other pages too, but freezes the application
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      if (_isPlaying) {
        audioPlayer.pause();
      } else {
      //  audioPlayer.setUrl(widget.url); // Maybe it shouldn't be here
        audioPlayer.play();
      }
      // _isPlaying = !_isPlaying;
    });
  }

  void _toggleLooping() {
    setState(() {
      _isLooping = !_isLooping;
      audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
    });
  }

  // void _toggleLoopMode() {
  //   _isLooping = !_isLooping;
  //    audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Add other icons here when implementing previous/next song, loop and shuffle features
            IconButton(
              icon: Icon(
                Icons.loop,
                color: _isLooping ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
              ),
              onPressed: _toggleLooping,
            ),
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              // Rounded corners
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 0),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  // color: widget.iconColor,
                  // size: widget.iconSize,
                  size: 42,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: _togglePlayback,
              ),
            ),
            // Playback rate display
            Text(
              '${_playbackRate.toStringAsFixed(1)}x',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
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
                      builder: (context, positionSnapshot) {
                        final position = positionSnapshot.data ?? Duration.zero;

                        return StreamBuilder<Duration?>(
                          stream: audioPlayer.durationStream,
                          builder: (context, durationSnapshot) {
                            final duration = durationSnapshot.data ?? Duration.zero;

                            return Column(
                              children: [
                                // TODO Add audio visualizer here (like: https://github.com/SerggioC/FlutterMusicPlayer/tree/master)
                                Slider(
                                  value: position.inSeconds.toDouble(),
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  activeColor: Color(0xff000000),
                                  inactiveColor: Color(0xffe0e0e0),
                                  thumbColor: Color(0xff000000),
                                  onChanged: (value) {
                                    audioPlayer.seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatTime(position), style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                    SizedBox(width: 10),
                                    Flexible(flex: 1, child: Text(widget.songName + ' - ' + widget.songArtist, overflow: TextOverflow.ellipsis)),
                                    // Text(' - '),
                                    // Text(widget.songArtist),
                                    SizedBox(width: 5),
                                    Text(formatTime(duration), style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
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

  // Thanks https://youtu.be/gJZWzi8BgBQ
  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
