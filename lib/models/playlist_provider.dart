import 'package:flutter/material.dart';
import 'song_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// Thanks https://youtu.be/Zr4j6W7nmpg
class PlaylistProvider extends ChangeNotifier {
  // Playlist of songs
  final List<SongModel> _playlist = [
    // Initial list of songs
    // SongModel(
    //   isSelected: true,
    //   songName: "Song 1",
    //   artistName: "Artist 1",
    //   coverImage: Uri.parse("assets/images/music-icon.png").toString(),
    //   audioPath: Uri.parse("asset:///assets/audio-example.mp3").toString(),
    //   BPM: 135
    // ),
    // ...
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLooping = false;
  double _playbackRate = 1.0;
  double _minPlaybackRate = 0.5;
  double _maxPlaybackRate = 2.0;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  int? _currentSongIndex;

  RangeValues _playbackRateRange = RangeValues(0.5, 2.0); // Default values for speed range


  // Getters
  List<SongModel> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  double get playbackRate => _playbackRate;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  
  // Getter to expose the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Getters and setters for minPlaybackRate and maxPlaybackRate
  double get minPlaybackRate => _minPlaybackRate;
  set minPlaybackRate(double value) {
    _minPlaybackRate = value;
    notifyListeners();
  }
  double get maxPlaybackRate => _maxPlaybackRate;
  set maxPlaybackRate(double value) {
    _maxPlaybackRate = value;
    notifyListeners();
  }

  // Getter and Setter for playbackRateRange
  RangeValues get playbackRateRange => _playbackRateRange;
  set playbackRateRange(RangeValues values) {
    _playbackRateRange = values;
    _minPlaybackRate = values.start; // Update minPlaybackRate
    _maxPlaybackRate = values.end;   // Update maxPlaybackRate
    notifyListeners();
  }

  // Other setters and methods
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
  
  set playbackRate(double newRate) {
    _playbackRate = newRate;
    notifyListeners();
  }

  // Reset playback rate to 1x whenActivate sync switch is disabled
  void resetPlaybackRate() {
    _playbackRate = 1.0;
    _audioPlayer.setSpeed(_playbackRate); // Update the audio player
    notifyListeners(); // Notify listeners about the change
  }

  void play() async {
    if (_currentSongIndex != null) {
      final song = _playlist[_currentSongIndex!];
      final mediaItem = MediaItem(
        id: song.audioPath,
        album: "Unknown Album",
        title: song.songName,
        artist: song.artistName,
        artUri: Uri.parse(song.coverImage),
        extras: {'BPM': song.BPM},
      );
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.audioPath),
          tag: mediaItem,
        ),
      );
      await _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();
    }
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      do { // Use a do-while loop to find the next selected song
        if (_currentSongIndex! < _playlist.length - 1) {
          _currentSongIndex = _currentSongIndex! + 1;
        } else {
          _currentSongIndex = 0;
        }
      } while (!_playlist[_currentSongIndex!].isSelected); // Loop until a selected song is found

      play();
    }
  }

  void playPreviousSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex != null) {
        do { // Use a do-while loop to find the previous selected song
          if (_currentSongIndex! > 0) {
            _currentSongIndex = _currentSongIndex! - 1;
          } else {
            _currentSongIndex = _playlist.length - 1;
          }
        } while (!_playlist[_currentSongIndex!].isSelected); // Loop until a selected song is found

        play();
      }
    }
  }

  void toggleLooping() {
    _isLooping = !_isLooping;
    _audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  SongModel? getMostRecentSong() {
    if (_playlist.isNotEmpty) {
      return _playlist.last;
    }
    return null;
  }

  void addSong(SongModel song) {
    _playlist.add(song);
    _currentSongIndex = _playlist.length - 1;
    notifyListeners();

    play(); // Play the song as soon as it's imported
  }

  PlaylistProvider() {
    _audioPlayer.positionStream.listen((position) {
      _currentDuration = position;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing != _isPlaying) {
        _isPlaying = state.playing;
        notifyListeners();
      }
      if (state.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
  }
}
