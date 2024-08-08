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
  
  List<FlSpot> _accData = []; // List to store accelerometer data points
  
  // Getter for accData
  List<FlSpot> get accData => _accData;

  StepDetectionProvider(this._playlistProvider) {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      _detectStep(event);
    });
  }

  int get stepCount => _stepCount;

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

      // // Add new accelerometer data to the list
      // _accData.add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), event.y));

      // // Keep only the latest 100 data points
      // if (_accData.length > 100) {
      //   _accData.removeAt(0);
      // }

      // notifyListeners(); // Notify listeners about the change in accData
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
    if (_stepInterval > 0) {
      double _stepFrequency = 1 / _stepInterval;
      double _userSPM = _stepFrequency * 60;

      // // Get the current song's BPM from the playlist provider
      // double? _originalBPM = _playlistProvider.playlist[_playlistProvider.currentSongIndex!].BPM;

      // Check if a song is loaded and playing
      if (_playlistProvider.currentSongIndex != null && _playlistProvider.isPlaying) {
        double? _originalBPM = _playlistProvider.playlist[_playlistProvider.currentSongIndex!].BPM;

        // if (_originalBPM != null) {
          double _playbackRate = _userSPM / _originalBPM; // Calculate playback rate
          double _clampedPlaybackRate = _playbackRate.clamp(0.5, 2.0);

          // Update the playback rate in the playlist provider
          _playlistProvider.playbackRate = _clampedPlaybackRate;
          _playlistProvider.audioPlayer.setSpeed(_clampedPlaybackRate);
        // }
      }
      notifyListeners(); // Without this it starts changing playback rate only after changing tabs
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