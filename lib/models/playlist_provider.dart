import 'package:flutter/material.dart';
import 'song_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for jsonEncode and jsonDecode
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart'; 

// Thanks https://youtu.be/Zr4j6W7nmpg
class PlaylistProvider extends ChangeNotifier {
  // Playlist of songs
  final List<SongModel> _playlist = [
    // Initial list of songs
    // SongModel(
    //   isSelected: true,
    //   songName: 'Song 1',
    //   artistName: 'Artist 1',
    //   coverImage: Uri.parse('assets/images/music-icon.png').toString(),
    //   audioPath: Uri.parse('asset:///assets/audio-example.mp3').toString(),
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

  // Add PlayerController
  PlayerController playerController = PlayerController(); 
  // Add a unique key for each song
  final Map<String, GlobalKey> _waveformKeys = {};

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

  GlobalKey getWaveformKey(String songPath) {
    if (!_waveformKeys.containsKey(songPath)) {
      _waveformKeys[songPath] = GlobalKey();
    }
    return _waveformKeys[songPath]!;
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
        album: 'Unknown Album',
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

      // Prepare playerController 
      await playerController.preparePlayer(path: song.audioPath);

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

    _savePlaylistToStorage(); // Save the updated playlist
  }

  void removeSong(int index) {
    _playlist.removeAt(index);
    // Adjust current song index
    if (_currentSongIndex != null && _currentSongIndex! >= index) {
      _currentSongIndex = _currentSongIndex! - 1;
      if (_currentSongIndex! < 0 && _playlist.isNotEmpty) {
        _currentSongIndex = 0;
      } else if (_playlist.isEmpty) {
        _currentSongIndex = null;
        pause();
      }
    }
    notifyListeners();

    _savePlaylistToStorage(); // Save the updated playlist
  }

  PlaylistProvider() {
    playerController = PlayerController();

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

    // Listen for changes in currentSongIndex and prepare a new playerController
    _audioPlayer.currentIndexStream.listen((index) { 
      if (index != null && index < _playlist.length) {
        final song = _playlist[index];

        // Create a new PlayerController 
        playerController.dispose(); // Dispose the old controller
        playerController = PlayerController(); // Create a new one
        playerController.preparePlayer(path: song.audioPath);
      }
    });
    
    _loadPlaylistFromStorage(); // Load playlist data on initialization
  }

  // Override dispose to dispose playerController
  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaylistFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load playlist data (based on SongModel structure)
    String? playlistJson = prefs.getString('playlist');

    if (playlistJson != null && playlistJson.isNotEmpty) {
      // Deserialize playlist data from JSON
      print('JSON String: $playlistJson');
      List<dynamic> decodedPlaylist = jsonDecode(playlistJson);
      _playlist.clear(); // Clear the current playlist
      for (var songData in decodedPlaylist) {
        _playlist.add(SongModel.fromJson(songData));
      }
      notifyListeners();
    }
  }

  Future<void> _savePlaylistToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Serialize playlist data to JSON
    List<Map<String, dynamic>> playlistData = _playlist.map((song) => song.toJson()).toList();
    String playlistJson = jsonEncode(playlistData);
    await prefs.setString('playlist', playlistJson);
  }


  // Export Playlist
  Future<void> exportPlaylist() async {
    try {
      // Get app documents directory
      // Directory? directory = await getExternalStorageDirectory(); // Use external storage
      // Get downloads directory
      Directory? downloadsDirectory = await getDownloadsDirectory(); // Use external storage
      if (downloadsDirectory == null) {
        throw Exception('External storage directory not found'); 
      }

      // Create a playlist file (e.g., 'playlist.json')
      // File playlistFile = File('${directory.path}/playlist.json');
      File playlistFile = File('${downloadsDirectory.path}/playlist.json'); 

      // Convert the playlist to JSON
      String playlistJson = jsonEncode(_playlist);

      // Write the JSON to the file
      await playlistFile.writeAsString(playlistJson);

      // Show a success message (you can use a SnackBar or Dialog)
      print('Playlist exported to: ${playlistFile.path}');

    } catch (e) {
      // Handle errors (e.g., show an error message)
      print('Error exporting playlist: $e');
    }
  }

  // Import Playlist
  Future<void> importPlaylist() async {
    try {
      // Pick a JSON file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        // Read the content of the selected file
        File file = File(result.files.single.path!);
        String playlistJson = await file.readAsString();

        // Decode the JSON data
        List<dynamic> decodedPlaylist = json.decode(playlistJson);

        // Clear the existing playlist
        _playlist.clear();

        // Add songs from the imported data
        for (var songData in decodedPlaylist) {
          _playlist.add(SongModel.fromJson(songData));
        }

        // Reset the player and notify listeners
        _audioPlayer.stop();
        _currentSongIndex = null;
        notifyListeners();

        // Show a success message
        print('Playlist imported successfully');
      }
    } catch (e) {
      // Handle errors (e.g., show an error message)
      print('Error importing playlist: $e');
    }
  }
}
