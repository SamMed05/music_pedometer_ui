import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonDrawer extends StatelessWidget {
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
                applicationVersion: '0.1.1',
                applicationLegalese: 'Developed by Samuel Mediani',
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Text('This app helps to sync songs to match your steps tempo.'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse('https://github.com/');
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
