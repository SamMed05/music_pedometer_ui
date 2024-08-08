import 'package:flutter/material.dart';
import 'audio_player_widget.dart';
import 'models/playlist_provider.dart';
import 'package:provider/provider.dart';
// import 'package:sensors_plus/sensors_plus.dart';
import 'step_detection_provider.dart';
import 'package:fl_chart/fl_chart.dart';

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
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "SPM vs BPM",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 23,
                              // color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage(
                                "assets/images/visualizer-placeholder.png"),
                            height: 230,
                            width: 280,
                            fit: BoxFit.cover,
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
                            SizedBox(height: 30),
                            // Step Frequency Chart
                            SizedBox(
                              height: 200, // Adjust height as needed
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
