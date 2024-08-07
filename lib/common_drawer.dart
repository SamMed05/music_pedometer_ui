import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CommonDrawer extends StatefulWidget {
  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String _versionNumber = ""; 

  // State variable to hold the version number
  @override
  void initState() {
    super.initState();
    // Fetch the version number and set it to the state variable (can't do it directly since it's of type Future)
    getVersionNumber().then((value) {
      setState(() {
        _versionNumber = value;
      });
    });
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    return version;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
              // backgroundBlendMode: BlendMode.overlay,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              showAboutDialog(
                context: context,
                applicationName: 'Music Pedometer',
                // applicationVersion: '0.1.3',
                applicationVersion: '$_versionNumber',
                applicationLegalese: 'Developed by Samuel Mediani',
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Text('This app helps to sync songs to match your steps tempo.'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse('https://github.com/SamMed05/music_pedometer_ui/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      'View on GitHub',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
