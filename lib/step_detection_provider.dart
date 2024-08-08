import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'models/playlist_provider.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';

class StepDetectionProvider with ChangeNotifier {
  final PlaylistProvider _playlistProvider;
  int _stepCount = 0;
  double _stepInterval = 0;
  List<double> _stepIntervals = [];
  double _windowSize = 150; // How many point to display on the chart
  double _bufferMilliseconds = 400; // Default buffer (500 ms corresponds to 120 BPM, it's 1/4 os 120)
  double _threshold = 7; // Threshold for step detection (Lower = more sensitive)
  DateTime? _lastStepTime;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _isRunningMode = false;
  bool _isSyncActive = true; // Track whether sync is active
  List<FlSpot> _accData = []; // List to store accelerometer data points
  

  // Getters and setters
  int get stepCount => _stepCount;

  List<FlSpot> get accData => _accData;

  bool get isSyncActive => _isSyncActive;
  set isSyncActive(bool value) {
    _isSyncActive = value;
    notifyListeners();
  }

  bool get isRunningMode => _isRunningMode;
  set isRunningMode(bool value) {
    _isRunningMode = value;
    // Adjust step detection parameters based on running mode (see below)
    if (_isRunningMode) {
      _bufferMilliseconds = 300; // Example values for running mode
      _threshold = 9;
    } else {
      _bufferMilliseconds = 400; // Example values for normal mode
      _threshold = 7;
    }
    notifyListeners();
  }


  // Listen to accelerometer data
  StepDetectionProvider(this._playlistProvider) {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      _detectStep(event);
    });
  }

  void _detectStep(AccelerometerEvent event) {
    double threshold = 10; // You might need to adjust this value
    if (event.y.abs() > threshold) {
      DateTime now = DateTime.now();

      if (_lastStepTime != null && now.difference(_lastStepTime!).inMilliseconds > _bufferMilliseconds) {
        double interval = now.difference(_lastStepTime!).inMilliseconds / 1000.0;

        _stepIntervals.add(interval);
        if (_stepIntervals.length > 10) {
          _stepIntervals.removeAt(0);
        }

        _stepInterval = _stepIntervals.reduce((a, b) => a + b) / _stepIntervals.length;

        _lastStepTime = now;
        _stepCount++;

        _syncMusicToSteps();
      } else if (_lastStepTime == null) {
        _lastStepTime = now;
      }
    }

    // Add new accelerometer data to the list
    _accData.add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), event.y));

    // Keep only the latest 100 data points
    if (_accData.length > _windowSize) {
      _accData.removeAt(0);
    }

    notifyListeners(); // Notify listeners about the change in accData (always executed)
  }

  void _syncMusicToSteps() {
    if (_stepInterval > 0  && _isSyncActive) { // Sync music only if sync switch is active
      double _stepFrequency = 1 / _stepInterval;
      double _userSPM = _stepFrequency * 60;

      // Check if a song is loaded and playing
      if (_playlistProvider.currentSongIndex != null && _playlistProvider.isPlaying) {
        // Get the current song's BPM from the playlist provider
        double? _originalBPM = _playlistProvider.playlist[_playlistProvider.currentSongIndex!].BPM;

        double _playbackRate = _userSPM / _originalBPM; // Calculate playback rate for sync

        // Clamp the playback rate using minPlaybackRate and maxPlaybackRate
        double clampedPlaybackRate = _playbackRate.clamp(
          _playlistProvider.minPlaybackRate,
          _playlistProvider.maxPlaybackRate,
        );

        // Update the playback rate in the playlist provider
        _playlistProvider.playbackRate = clampedPlaybackRate;
        _playlistProvider.audioPlayer.setSpeed(clampedPlaybackRate);
      }
      notifyListeners(); // Without this it starts changing playback rate only after changing tabs
    }
    if (!_isSyncActive) {
      // _playlistProvider.audioPlayer.setSpeed(1);
      _playlistProvider.resetPlaybackRate(); // Due to the nature of the _syncMusicToSteps function, the playback rate is only reset to 1x at the detection of the first step after disabling the switch
      notifyListeners();
    }
  }

  // Getters and Setters for bufferMilliseconds and threshold
  double get bufferMilliseconds => _bufferMilliseconds;
  set bufferMilliseconds(double value) {
    _bufferMilliseconds = value;
    notifyListeners(); // Notify listeners about the change
  }

  double get threshold => _threshold;
  set threshold(double value) {
    _threshold = value;
    notifyListeners(); // Notify listeners about the change
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}