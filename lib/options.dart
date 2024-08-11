import 'package:flutter/material.dart';
import 'package:music_pedometer_ui/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'step_detection_provider.dart';
import 'models/playlist_provider.dart';

// Global variables
// double maxPlaybackRate = 2.0;
// double minPlaybackRate = 0.5;


class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  // bool _darkTheme = false;
  // bool _isRunningMode = false;

  // RangeValues _playbackRateRange = RangeValues(minPlaybackRate, maxPlaybackRate);
  RangeValues _compatibleBPMRange = RangeValues(80, 140); // Default compatible BPM range

  // Tempo Mode (default to Normal)
  //String _tempoMode = 'Normal'; // This variable doesn't need to be saved when the app is closed, so it's here
  
  bool _isSyncActive = true; // Track whether sync is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Activate Sync Switch
            SwitchListTile(
              value: _isSyncActive,
              title: Text(
                "Activate Sync",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 15,
                  // color: Color(0xff000000),
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                "Sync music BPM to your steps",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                  fontSize: 13,
                  // color: Color(0xff000000),
                ),
                textAlign: TextAlign.start,
              ),
              onChanged: (value) {
                setState(() {
                  _isSyncActive = value;
                  // Update the StepDetectionProvider's sync state
                  Provider.of<StepDetectionProvider>(context, listen: false).isSyncActive = value;
                });
              },
              // tileColor: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).canvasColor,
              secondary: Icon(Icons.timer, size: 24),
              selected: false,
              dense: true,
            ),

            // Running Mode Switch
            SwitchListTile(
              // value: _isRunningMode, // Doing it in this way makes it always reset to false when changing page
              value: Provider.of<StepDetectionProvider>(context).isRunningMode, // Access from provider to prevent resetting
              title: Text(
                "Running Mode",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                "Adjust settings for running",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  Provider.of<StepDetectionProvider>(context, listen: false).isRunningMode = value;
                });
              },
              secondary: Icon(Icons.directions_run, size: 24),
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).canvasColor,
              dense: true,
            ),

            // Dark Mode Switch
            SwitchListTile(
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              title: Text(
                "Activate Dark Mode",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                ),
              ),
              secondary: Icon(Icons.dark_mode, size: 24),
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).canvasColor,
              dense: true,
            ),

            // Playback Change Range Slider
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adjust range of playback rate changes",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(".5x", style: TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        width: 780 / MediaQuery.of(context).devicePixelRatio,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RangeSlider(
                            // values: _playbackRateRange,
                            values: Provider.of<PlaylistProvider>(context).playbackRateRange, // Access from provider
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            labels: RangeLabels(
                              // _playbackRateRange.start.toStringAsFixed(1),
                              // _playbackRateRange.end.toStringAsFixed(1),
                              Provider.of<PlaylistProvider>(context).playbackRateRange.start.toStringAsFixed(1),
                              Provider.of<PlaylistProvider>(context).playbackRateRange.end.toStringAsFixed(1),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                // _playbackRateRange = values;
        
                                // Update the PlaylistProvider's playback rate range (see step 4)
                                // Provider.of<PlaylistProvider>(context, listen: false).minPlaybackRate = values.start;
                                // Provider.of<PlaylistProvider>(context, listen: false).maxPlaybackRate = values.end;
                                Provider.of<PlaylistProvider>(context, listen: false).playbackRateRange = values;
                              });
                            },
                            // activeColor: Colors.black,
                            // inactiveColor: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Text("2x", style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
        
            // Slider for adjusting the buffer
            Text(
              'Buffer: ${Provider.of<StepDetectionProvider>(context).bufferMilliseconds.round()} ms',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 13,
              ),
            ),
            Slider(
              value: Provider.of<StepDetectionProvider>(context).bufferMilliseconds,
              min: 100,
              max: 1000,
              divisions: 9,
              label: Provider.of<StepDetectionProvider>(context).bufferMilliseconds.round().toString(),
              onChanged: (value) {
                Provider.of<StepDetectionProvider>(context, listen: false).bufferMilliseconds = value;
              },
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Colors.grey.withOpacity(0.5),
            ),
            
            // Slider for adjusting the threshold
            Text(
              'Threshold: ${Provider.of<StepDetectionProvider>(context).threshold}',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 13,
              ),
            ),
            Slider(
              value: Provider.of<StepDetectionProvider>(context).threshold,
              min: 5,
              max: 20,
              divisions: 15,
              label: Provider.of<StepDetectionProvider>(context).threshold.toString(),
              onChanged: (value) {
                Provider.of<StepDetectionProvider>(context, listen: false).threshold = value;
              },
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Colors.grey.withOpacity(0.5),
            ),
        
            // Compatible BPM Range Slider
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Allow songs in this BPM range",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("40", style: TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        width: 780 / MediaQuery.of(context).devicePixelRatio,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RangeSlider(
                            values: _compatibleBPMRange,
                            min: 40,
                            max: 200,
                            divisions: 160,
                            labels: RangeLabels(
                              _compatibleBPMRange.start.round().toString(),
                              _compatibleBPMRange.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _compatibleBPMRange = values;
                                // Update the StepDetectionProvider's compatible BPM range
                                Provider.of<StepDetectionProvider>(context, listen: false).compatibleBPMRange = values;
                              });
                            },
                          ),
                        ),
                      ),
                      Text("200", style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Playback rate smoothing factor",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Slider(
                    value: Provider.of<StepDetectionProvider>(context).smoothingFactor,
                    min: 0.01,
                    max: 1.0,
                    divisions: 99,
                    label: Provider.of<StepDetectionProvider>(context).smoothingFactor.toStringAsFixed(2),
                    onChanged: (value) {
                      Provider.of<StepDetectionProvider>(context, listen: false).smoothingFactor = value;
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey.withOpacity(0.5),
                  ),
                  Text(
                    "How quickly the music playback rate adapts to your steps. Lower values = smoother transitions (but more audio artifacts).",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}