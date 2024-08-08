import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'models/playlist_provider.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StepDetectionProvider with ChangeNotifier {
  final PlaylistProvider _playlistProvider;
  int _stepCount = 0;
  double _stepInterval = 0;
  List<double> _stepIntervals = [];
  double _windowSize = 150; // How many point to display on the chart
  double _bufferMilliseconds = 400; // Default buffer (500 ms corresponds to 120 BPM, it's 1/4 os 120)
  double _threshold = 6; // Threshold for step detection (Lower = more sensitive)
  DateTime? _lastStepTime;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _isRunningMode = false;
  bool _isSyncActive = true; // Track whether sync is active

  List<FlSpot> _accData = []; // List to store accelerometer data points

  DateTime _startTime = DateTime.now(); // Used to calculate the elapsed time for step frequency calculation
  List<FlSpot> _stepFrequencyData = []; // List to store step frequency data points
  
  RangeValues _compatibleBPMRange = RangeValues(80, 140); // Default range

  // Getters and setters
  int get stepCount => _stepCount;
  List<FlSpot> get accData => _accData;
  List<FlSpot> get stepFrequencyData => _stepFrequencyData;

  bool get isSyncActive => _isSyncActive;
  set isSyncActive(bool value) {
    _isSyncActive = value;
    notifyListeners();
  }

  bool get isRunningMode => _isRunningMode;
  set isRunningMode(bool value) {
    _isRunningMode = value;
    // Adjust step detection parameters based on running mode (TODO Make these values editable in options)
    if (_isRunningMode) {
      _bufferMilliseconds = 300;
      _threshold = 10;
    } else {
      _bufferMilliseconds = 400;
      _threshold = 6;
    }
    notifyListeners();
  }

  RangeValues get compatibleBPMRange => _compatibleBPMRange;
  set compatibleBPMRange(RangeValues values) {
    _compatibleBPMRange = values;
    notifyListeners();
  }

  // Getter for the current SPM (Steps Per Minute) of the user
  double get currentSPM {
    if (_stepInterval > 0) {
      double stepFrequency = 1 / _stepInterval;
      return stepFrequency * 60;
    } else {
      return 0.0; // Return 0 if no steps have been detected yet
    }
  }


  // Listen to accelerometer data
  StepDetectionProvider(this._playlistProvider) {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      _detectStep(event);
    });
  }

  void _detectStep(AccelerometerEvent event) {
    // Calculate magnitude of acceleration vector
    double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    
    // Subtract gravitational offset
    magnitude -= 9.81; // Approximate value for gravitational acceleration

    if (magnitude.abs() > _threshold) {
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
    _accData.add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), magnitude));

    // Keep only the latest 100 data points
    if (_accData.length > _windowSize) {
      _accData.removeAt(0);
    }


    // Calculate step frequency
    double stepFrequency = _stepCount / (DateTime.now().difference(_startTime).inSeconds);

    // Calculate normalized timestamp (in seconds)
    double normalizedTimestamp = DateTime.now().difference(_startTime).inSeconds.toDouble();

    // Add new step frequency data to the list
    _stepFrequencyData.add(FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), stepFrequency));
    // _stepFrequencyData.add(FlSpot(normalizedTimestamp, stepFrequency));

    // Keep only the latest data points
    if (_stepFrequencyData.length > 100) { // TODO Increasing this value makes the app crash because of an error in fl_chart rendering ('input >= 1.0': is not true)
      _stepFrequencyData.removeAt(0);
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