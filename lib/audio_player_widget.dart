import 'package:flutter/material.dart';
import 'package:music_pedometer_ui/models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

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
        final playerController = playlistProvider.playerController; // Access playerController
        final currentIndex = playlistProvider.currentSongIndex;
        final currentSong = currentIndex != null && currentIndex < playlistProvider.playlist.length
            ? playlistProvider.playlist[currentIndex]
            : null;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TODO Add shuffle
                IconButton(
                  icon: Icon(
                    Icons.loop_rounded,
                    // TODO Fix colors in dark mode
                    color: playlistProvider.isLooping ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: playlistProvider.toggleLooping,
                ),
                IconButton(
                  onPressed: playlistProvider.playPreviousSong, 
                  icon: Icon(Icons.skip_previous_rounded),
                  iconSize: 35,
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
                      playlistProvider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 42,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: playlistProvider.pauseOrResume,
                  ),
                ),
                IconButton(
                  onPressed: playlistProvider.playNextSong, 
                  icon: Icon(Icons.skip_next_rounded),
                  iconSize: 35,
                ),
                // Playback rate display
                Text(
                  // '${playlistProvider.playbackRate.toStringAsFixed(1)}x',
                  '${playlistProvider.playbackRate.toStringAsFixed(2)}x',
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
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            // Static Waveform
                            currentSong != null
                                ? Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: AudioFileWaveforms(
                                      // Rebuild the widget when song changed
                                      key: playlistProvider.getWaveformKey(currentSong.audioPath),

                                      size: Size(MediaQuery.of(context).size.width, 48),
                                      playerController: playerController,
                                      waveformType: WaveformType.fitWidth,
                                      enableSeekGesture: true,
                                      playerWaveStyle: PlayerWaveStyle(
                                        fixedWaveColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        spacing: 7,
                                        scaleFactor: 70
                                        // extendWaveform: true,
                                        // showMiddleLine: false, // Disable the middle line
                                      ),
                                    ),
                                )
                                : SizedBox(),

                            // Live Waveform
                            // currentSong != null
                            //     ? AudioFileWaveforms(
                            //         size: Size(MediaQuery.of(context).size.width, 100),
                            //         playerController: playerController,
                            //         enableSeekGesture: true,
                            //         playerWaveStyle: PlayerWaveStyle(
                            //           fixedWaveColor: Theme.of(context).colorScheme.primary,
                            //           liveWaveColor: Theme.of(context).colorScheme.primary,
                            //           waveCap: StrokeCap.round,
                            //         ),
                            //       )
                            //     : SizedBox(),

                            // Slider
                            StreamBuilder<Duration?>(
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
                                          // activeColor: Color(0xff000000),
                                          inactiveColor: Color.fromARGB(135, 190, 190, 190),
                                          // thumbColor: Color(0xff000000),
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
                          ],
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
