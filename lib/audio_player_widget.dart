import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_pedometer_ui/models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'models/playlist_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        final audioPlayer = playlistProvider.audioPlayer;
        final currentIndex = playlistProvider.currentSongIndex;
        final currentSong = currentIndex != null && currentIndex < playlistProvider.playlist.length
            ? playlistProvider.playlist[currentIndex]
            : null;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TODO Add other icons here when implementing previous/next song, loop and shuffle features
                IconButton(
                  icon: Icon(
                    Icons.loop,
                    color: playlistProvider.isLooping ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
                  ),
                  onPressed: playlistProvider.toggleLooping,
                ),
                IconButton(
                  onPressed: playlistProvider.playPreviousSong, 
                  icon: Icon(Icons.skip_previous),
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
                      playlistProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 42,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: playlistProvider.pauseOrResume,
                  ),
                ),
                IconButton(
                  onPressed: playlistProvider.playNextSong, 
                  icon: Icon(Icons.skip_next),
                ),
                // Playback rate display
                Text(
                  '${playlistProvider.playbackRate.toStringAsFixed(1)}x',
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
                                      // TODO Fix colors for light/dark modes
                                      activeColor: Color(0xff000000),
                                      inactiveColor: Color(0xffe0e0e0),
                                      thumbColor: Color(0xff000000),
                                      onChanged: (value) {
                                        // When the user is sliding
                                        audioPlayer.seek(Duration(seconds: value.toInt()));
                                      },
                                      onChangeEnd: (double double) {
                                        // Sliding has finished, go to that position in song duration
                                        playlistProvider.seek(Duration(seconds: double.toInt()));
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(formatTime(position), style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                        SizedBox(width: 10),
                                        // Display song name and artist name, if not null
                                        Flexible(flex: 1,
                                          child: Text(
                                            currentSong != null
                                                ? '${currentSong.songName} - ${currentSong.artistName}'
                                                : 'No song playing',
                                            overflow: TextOverflow.ellipsis,
                                          ),),
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
                      // TODO Add here the step count
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  // Thanks https://youtu.be/gJZWzi8BgBQ
  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
