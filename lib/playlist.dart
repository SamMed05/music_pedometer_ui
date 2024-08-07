import 'package:flutter/material.dart';
import 'models/song_model.dart';
import 'package:file_picker/file_picker.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<SongModel> songs = [];
  bool onlyCompatibleSongs = true;
  FilePickerResult? songResult; // ? operator means that NULL is allowed (see https://dart.dev/null-safety)
  String _fileName = '';

  void _getSongs() {
    songs = SongModel.getSongs();
  }
  // or
  // void _getSongs() {
  //   setState(() {
  //     songs = SongModel.getSongs();
  //   });
  // }

  // not needed
  // @override
  // void initState() {
  //   _getSongs();
  // }

  @override
  Widget build(BuildContext context) {
    _getSongs();
    bool isChecked = false;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SwitchListTile(
            value: true,
            title: Text(
              "Only compatible",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 15,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            subtitle: Text(
              "Recommend songs with tempo matching your current SPM",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                fontSize: 11,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            onChanged: (value) {},
            tileColor: Color.fromARGB(84, 199, 199, 199),
            activeColor: Theme.of(context).colorScheme.onPrimary,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).canvasColor,
            controlAffinity: ListTileControlAffinity.trailing,
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            secondary: Icon(Icons.filter_alt_outlined,
                color: Color(0xff212435), size: 24),
            selected: false,
            selectedTileColor: Color(0x42000000),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Songs",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "BPM",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              // List all the songs
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongItem(index, isChecked);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickFile();
          // TODO Make the SnackBar appear AFTER the user finishes loading a file (then adapt displayed text based on the result)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: songResult == null 
                  ? const Text('No song chosen') 
                  : Text ('Imported song ' + songResult!.files.single.name), // ! operator means songResult can't be NULL
              // action: SnackBarAction(
              //   label: 'Undo',
              //   onPressed: () {
              //     // Some code to undo the change.
              //   },
              // ),
            ),
          );
        },
        child: const Icon(Icons.audio_file),
      ),
    );
  }
  
  void pickFile() async {
    final songResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'ogg'], // https://developer.android.com/media/media3/exoplayer/supported-formats and https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/MultimediaPG/UsingAudio/UsingAudio.html
    );
    setState(() {});
    if (songResult != null) {
      final path = songResult!.files.single.path!;
      _fileName = songResult.files.single.name;
      setState(() {}); // Update state
    } else {
      // User canceled the picker
    }
  }

  Column SongItem(int index, bool isChecked) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Checkbox(
                  //value: isChecked,
                  value: songs[index].isSelected,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: Color.fromARGB(255, 145, 145, 145),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color.fromARGB(66, 70, 70, 70),
                  splashRadius: 20,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(6),
                  width: 180,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(41, 128, 128, 128),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0x4d9e9e9e), width: 0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x1f000000),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0x4d9e9e9e), width: 0),
                        ),
                        child: ClipRRect( // Make rounded corners in the album cover images
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: songs[index].coverImage,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                songs[index].songName,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Text(
                                songs[index].artistName,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 13,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                padding: EdgeInsets.all(3),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Color.fromARGB(41, 128, 128, 128),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Color(0x4d9e9e9e), width: 0),
                ),
                child: Text(
                  songs[index].BPM.toString(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
