import 'package:flutter/material.dart';
// import 'custom_app_bar.dart';
// import 'common_drawer.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool _darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: _darkTheme
        ? ColorFilter.matrix(<double>[
              -1, 0, 0, 0, 255, // Invert red
              0, -1, 0, 0, 255, // Invert green
              0, 0, -1, 0, 255, // Invert blue
              0, 0, 0, 1, 0, // No change to alpha
            ])
          : ColorFilter.matrix(<double>[
              1, 0, 0, 0, 0, // Normal red
              0, 1, 0, 0, 0, // Normal green
              0, 0, 1, 0, 0, // Normal blue
              0, 0, 0, 1, 0, // No change to alpha
            ]),
      child: Scaffold(
        // appBar: CustomAppBar(title: "Options"),
        // drawer: CommonDrawer(),
        body: Column(
          children: [
            ListTile(
              title: Text(
                "Dark theme",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
              trailing: Switch(
                value: _darkTheme,
                onChanged: (value) {
                  setState(() {
                    _darkTheme = value;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
                activeTrackColor: Theme.of(context).colorScheme.secondary,
                inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                inactiveTrackColor: Theme.of(context).canvasColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
