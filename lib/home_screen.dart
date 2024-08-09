import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'audio_player_widget.dart';
import 'models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'step_detection_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSyncActive = true; // Track whether sync is active
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          toolbarHeight: 0, // Remove empty white space
          elevation: 4,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.monitor_heart_sharp),
                // text: "Rhythm",
              ),
              Tab(
                icon: Icon(Icons.directions_walk_sharp),
                // text: "Steps",
              ),
              Tab(
                icon: Icon(Icons.bar_chart_sharp),
                // text: "Accelerometer",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded( // Without this everything is white
              child: TabBarView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "SPM vs BPM",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              // color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "This is your current step frequency (SPM) compared to the original BPM (tempo) of the song",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              // color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Consumer<StepDetectionProvider>(
                            builder: (context, stepDetectionProvider, child) {
                              final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
                              final currentSong = playlistProvider.getMostRecentSong();
                              double currentBPM = currentSong?.BPM ?? 0.0; // Get current song BPM or default to 0.0
                              double currentSPM = stepDetectionProvider.currentSPM; // Get current SPM
                              double percentageDifference = ((currentSPM - currentBPM) / currentBPM) * 100; // Calculate percentage difference
                              double playbackRateChange = playlistProvider.playbackRate - 1.0; // Calculate playback rate change
                              double playbackRateBPMEquivalent = playbackRateChange * currentBPM; // Calculate playback rate BPM equivalent
                              double currentPlaybackRate = playlistProvider.playbackRate;

                              return SizedBox(
                                height: 270,
                                // Useful reference: https://help.syncfusion.com/flutter/radial-gauge/axes
                                child: SfRadialGauge(
                                  enableLoadingAnimation: true,
                                  // animationDuration: 2000,
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      minimum: -100,
                                      maximum: 100.01, // With 100 the last label is missing
                                      showLabels: true,
                                      showTicks: true,
                                      minorTicksPerInterval: 4,
                                      labelsPosition: ElementsPosition.inside,
                                      axisLabelStyle: GaugeTextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                      ticksPosition: ElementsPosition.outside,
                                      minorTickStyle: MinorTickStyle(color: const Color(0xFF919191),
                                        thickness: 1.3,
                                        length: 0.04,
                                        lengthUnit: GaugeSizeUnit.factor),
                                      majorTickStyle: MajorTickStyle(color: const Color(0xFF000000),
                                        thickness: 1.7,
                                        length: 0.08,
                                        lengthUnit: GaugeSizeUnit.factor),
                                      canScaleToFit: true,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.15,
                                        cornerStyle: CornerStyle.bothCurve,
                                        // color: Colors.black12,
                                        gradient: SweepGradient(
                                          center: FractionalOffset.center,
                                          colors: <Color>[
                                            Colors.white,
                                            Colors.black,
                                            Colors.black,
                                            Colors.black,
                                            Colors.white
                                          ],
                                          stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
                                          transform: GradientRotation(3.1415/4), // 45 degrees
                                        ),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        // Main pointer (user SPM)
                                        NeedlePointer(
                                          value: percentageDifference,
                                          needleLength: 0.55,
                                          // enableAnimation: true,
                                          // animationDuration: 100,
                                          needleStartWidth: 1.3,
                                          needleEndWidth: 3,
                                          knobStyle: KnobStyle(
                                            knobRadius: 0.4,
                                            color: Colors.black,
                                          ),
                                          tailStyle: TailStyle(
                                            width: 3,
                                            length: 0.2,
                                            color: Colors.black,
                                            lengthUnit: GaugeSizeUnit.factor,
                                          ),
                                        ),
                                        // Secondary pointer (current playback rate)
                                        RangePointer(
                                          // value: playbackRateBPMEquivalent,
                                          // value: percentageDifference,
                                          // Thanks https://stackoverflow.com/a/345204/13122341
                                          value: (currentPlaybackRate / 2) * 200 - 100, // Map (0x)(2x) to (-100)(+100) values
                                          width: 0.15,
                                          enableAnimation: true,
                                          animationDuration: 100,
                                          color: Colors.grey.withOpacity(0.3),
                                          sizeUnit: GaugeSizeUnit.factor,
                                        ),
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        // Percentage difference annotation
                                        // Annotation for the SPM value at the needle tip
                                        GaugeAnnotation(
                                          // axisValue: (currentSPM-currentBPM),
                                          axisValue: percentageDifference,
                                          widget: Container(
                                            width: 33,
                                            height: 33,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Color(0xFF000000),
                                                width: 3.0
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                currentSPM.toStringAsFixed(0),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // angle: -90,
                                          positionFactor: 0.842, // Adjust position to be at the needle tip
                                        ),
                                        GaugeAnnotation(
                                          widget: Container(
                                            child: Text(
                                              'SPM ' + (currentSPM > currentBPM ? '>' : '<') + ' BPM',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          angle: 90,
                                          positionFactor: 0.8,
                                        ),
                                        GaugeAnnotation(widget: 
                                          Container(
                                            child: Text(
                                              '${percentageDifference.toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Steps tab
                  Center(
                    child: Consumer<StepDetectionProvider>(
                      builder: (context, stepDetectionProvider, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Step Count
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Center the row
                                children: [
                                  Text(
                                    "${stepDetectionProvider.stepCount}",
                                    style: TextStyle(
                                      fontSize: 45.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Padding( // Column with alignment to end doesn't work
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                    child:
                                      Text(
                                        "steps",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                            // Display Current SPM
                            SizedBox(height: 5),
                            Text(
                              "You are walking at ${stepDetectionProvider.currentSPM.toStringAsFixed(0)} SPM", // Display SPM with 0 decimal places
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Step Frequency Chart
                            SizedBox(
                              height: 200, // Set a fixed height
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: stepDetectionProvider.stepFrequencyData, // Use step frequency data
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ],
                                  gridData: FlGridData(
                                    show: false,
                                    drawVerticalLine: true,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Color.fromARGB(255, 146, 146, 146),
                                      strokeWidth: 0.5,
                                    ),
                                    getDrawingVerticalLine: (value) => FlLine(
                                      color: Color.fromARGB(255, 146, 146, 146),
                                      strokeWidth: 0.5,
                                    ),
                                  ),
                                  lineTouchData: LineTouchData(enabled: false),

                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                      )
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                      color: Color.fromARGB(0, 255, 255, 255),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
                  ),

                  // Accelerometer tab
                  Center(
                    // child: Text("Third tab"),
                    child: Consumer<StepDetectionProvider>( // Access the StepDetectionProvider here
                      builder: (context, stepDetectionProvider, child) {
                        return SizedBox( // Use SizedBox to constrain the chart's size
                          height: 300,
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: stepDetectionProvider.accData,
                                  isCurved: true,
                                  color: Theme.of(context).colorScheme.primary,
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ],

                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true, // Show right titles
                                    reservedSize: 40, // Reserve space for left titles
                                  )
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true, // Show left titles
                                    reservedSize: 40, // Reserve space for left titles
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false), // Hide top titles
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false), // Hide bottom titles
                                ),
                              ),
                              // borderData: FlBorderData(show: false), // Hide chart border
                              // gridData: FlGridData(show: true), // Show grid lines
                              
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Color.fromARGB(0, 255, 255, 255),
                                  width: 2,
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Color.fromARGB(255, 146, 146, 146),
                                  strokeWidth: 0.5,
                                ),
                                getDrawingVerticalLine: (value) => FlLine(
                                  color: Color.fromARGB(255, 146, 146, 146),
                                  strokeWidth: 0.5,
                                ),
                              ),
                              lineTouchData: LineTouchData(enabled: false),
                              minY: -15, // Fix Y-axis minimum value
                              maxY: 15,  // Fix Y-axis maximum value
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
            Divider(
              // See https://api.flutter.dev/flutter/material/Divider-class.html
              height: 10,
              thickness: 1,
              color: Theme.of(context).colorScheme.onSecondary,
              // indent: 40,
              // endIndent: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [Consumer<PlaylistProvider>(
                builder: (context, playlistProvider, child) {
                  final mostRecentSong = playlistProvider.getMostRecentSong();
                  return mostRecentSong != null
                      ? AudioPlayerWidget()
                      : Text("No songs available. Import one from the playlist page ➡️");
                }
                ),],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SwitchListTile(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          onChanged: (value) {
            setState(() {
              _isSyncActive = value;
              // Update the StepDetectionProvider's sync state
              Provider.of<StepDetectionProvider>(context, listen: false).isSyncActive = value;
            });
          },
          controlAffinity: ListTileControlAffinity.trailing,
          dense: true,
          // tileColor: Theme.of(context).colorScheme.onSecondary,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveThumbColor: Theme.of(context).colorScheme.secondary,
          inactiveTrackColor: Theme.of(context).canvasColor,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          secondary: Icon(
            Icons.timer,
            // color: Color(0xff000000),
            size: 24
          ),
          selected: false,
          selectedTileColor: Color(0x42000000),
        ),
      ),
    );
  }
}
