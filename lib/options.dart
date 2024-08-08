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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text(
              "Enable Dark Mode",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                // color: Color(0xff000000),
              ),
            ),
            trailing: Switch(
              value: 
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) => 
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).canvasColor,
            ),
          ),
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
                    // color: Color(0xff000000),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(".5x", style: TextStyle(fontWeight: FontWeight.w600)),
                    Container(
                      width: 780 / MediaQuery.of(context).devicePixelRatio,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
          Slider(
            value: Provider.of<StepDetectionProvider>(context).bufferMilliseconds,
            min: 100,
            max: 1000,
            divisions: 9,
            label: Provider.of<StepDetectionProvider>(context).bufferMilliseconds.round().toString(),
            onChanged: (value) {
              Provider.of<StepDetectionProvider>(context, listen: false).bufferMilliseconds = value;
            },
          ),
          Text('Buffer: ${Provider.of<StepDetectionProvider>(context).bufferMilliseconds.round()} ms'),

          // Slider for adjusting the threshold
          Slider(
            value: Provider.of<StepDetectionProvider>(context).threshold,
            min: 5,
            max: 20,
            divisions: 15,
            label: Provider.of<StepDetectionProvider>(context).threshold.toString(),
            onChanged: (value) {
              Provider.of<StepDetectionProvider>(context, listen: false).threshold = value;
            },
          ),
          Text('Threshold: ${Provider.of<StepDetectionProvider>(context).threshold}'),

          SwitchListTile(
            // value: _isRunningMode, // Doing it in this waymakes it always reset to false when changing page
            value: Provider.of<StepDetectionProvider>(context).isRunningMode, // Access from provider to prevent resetting
            title: Text("Running Mode"),
            onChanged: (value) {
              setState(() {
                // _isRunningMode = value;
                // Update the StepDetectionProvider's running mode state (see step 5)
                Provider.of<StepDetectionProvider>(context, listen: false).isRunningMode = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.onPrimary,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).canvasColor,
            // ...
          ),
        ],
      ),
    );
  }
}