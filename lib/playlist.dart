import 'package:flutter/material.dart';
import 'models/song_model.dart';
import 'package:file_picker/file_picker.dart';
import 'models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'step_detection_provider.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  _PlaylistPage createState() => _PlaylistPage();
}

class _PlaylistPage extends State<Playlist> {
  // Get playlist provider
  late final dynamic playlistProvider;
  bool _onlyCompatibleSongs = false; // Initially false

  bool onlyCompatibleSongs = true;
  
  FilePickerResult? songResult; // ? operator means that NULL is allowed (see https://dart.dev/null-safety)

  @override
  void initState() {
    super.initState();

    // Get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // Go to a song
  // TODO Change song when tapping on a playlist item
  void goToSong(int songIndex) {
    // Update current song index
    playlistProvider.currentSongIndex = songIndex;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        bool isChecked = false;

        // Get playlist
        final playlist = playlistProvider.playlist;

        // Get current song index
        // final currentSongIndex = playlistProvider.currentSongIndex;

        // Get current song
        // final currentSong = currentSongIndex != null ? playlist[currentSongIndex] : null;

        // Return scaffold UI
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SwitchListTile(
                value: _onlyCompatibleSongs,
                onChanged: (value) {
                  setState(() {
                    _onlyCompatibleSongs = value;
                    _updateSongSelection(); // Update song selections based on the switch state
                  });
                },
                title: Text(
                  'Only compatible songs',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    // color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.start,
                ),
                subtitle: Text(
                  'Recommend songs that are in your BPM range (edit in Options)',
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
                tileColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.onPrimary,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                inactiveTrackColor: Theme.of(context).canvasColor,
                controlAffinity: ListTileControlAffinity.trailing,
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                secondary: Icon(
                  Icons.filter_alt_rounded,
                  // color: Color(0xff212435),
                  size: 24
                ),
                selected: false,
                // selectedTileColor: Color(0x42000000),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        // color: Color(0xff000000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Songs',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                        // color: Color(0xff000000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Text(
                        'BPM',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          // color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  // List all the songs
                  itemCount: playlist.length,
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
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.audio_file_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
    });
  }

  void pickFile() async {
    final songResult = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple file selection
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'ogg', 'aac'], // https://developer.android.com/media/media3/exoplayer/supported-formats and https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/MultimediaPG/UsingAudio/UsingAudio.html
    );
    if (songResult != null) {
      // Iterate over each selected file
      for (PlatformFile file in songResult.files) {
        final path = file.path!;
        final fileName = file.name;

        // Create a new SongModel instance
        final newSong = SongModel(
          isSelected: true,
          songName: fileName,
          artistName: '/',
          coverImage: Uri.parse('assets/images/music-icon.png').toString(),
          audioPath: path,
          BPM: 0,
        );

        // Show dialog to enter BPM for each song
        bool isSongAdded = await _showBPMDialog(newSong);

        if (isSongAdded) {
          playlistProvider.addSong(newSong);

          // Show a SnackBar for each successfully imported song
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Imported song: $fileName'),
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      // Show a SnackBar if no songs were selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No songs chosen'),
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  Future<bool> _showBPMDialog(SongModel song) async {
    final TextEditingController bpmController = TextEditingController(); // To control the text that is displayed in the text field
    bool isSongAdded = false;

    // Use await, otherwise when showDialog is called, the execution of the surrounding code 
    // (like the SnackBar calls) continues without waiting for the dialog to be dismissed
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter BPM for ${song.songName}',
            style: TextStyle(
              fontSize: 20,
            )
          ),
          content: TextField(
            controller: bpmController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter song BPM (required)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                final bpm = double.tryParse(bpmController.text) ?? 0;

                // Prevent user from entering 0 BPM (or inserting a song by pressing OK without entering any value)
                if (bpm == 0) {
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    // Update the BPM of the song
                    song.BPM = bpm;
                  });

                  isSongAdded = true; // Set to true only when OK is pressed
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                isSongAdded = false; // Set to false if Cancel is pressed
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return isSongAdded;
  }

  void _updateSongSelection() {
    if (_onlyCompatibleSongs) {
      // Get the user's current SPM
      // double userSPM = Provider.of<StepDetectionProvider>(context, listen: false).currentSPM;
      RangeValues bpmRange = Provider.of<StepDetectionProvider>(context, listen: false).compatibleBPMRange;

      // Iterate through the playlist and update isSelected based on BPM compatibility
      for (SongModel song in playlistProvider.playlist) {
        song.isSelected = song.BPM >= bpmRange.start && song.BPM <= bpmRange.end;
      }
    } else {
      // Select all songs if the switch is off
      for (SongModel song in playlistProvider.playlist) {
        song.isSelected = true;
      }
    }

    playlistProvider.notifyListeners(); // Notify listeners to rebuild the UI
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
                  value: playlistProvider.playlist[index].isSelected,
                  onChanged: (value) {
                    setState(() {
                      // isChecked = value!;
                      // Update the isSelected property in the SongModel
                      playlistProvider.playlist[index].isSelected = value!;
                      playlistProvider.notifyListeners(); // Notify listeners of the change
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
                child: InkWell( // Better than GestureDetector
                  onTap: () {
                    // Play the song at the given index
                    goToSong(index);
                  },
                  onLongPress: () { // Add onLongPress callback
                    _showDeleteConfirmationDialog(index); // Show confirmation dialog
                  },
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(6),
                    width: 180,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x1f000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0x4d9e9e9e), width: 1),
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
                          child: ClipRRect(
                            // Make rounded corners in the album cover images
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: AssetImage(playlistProvider.playlist[index].coverImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      SizedBox(width: 2), // Add some spacing between image and text
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  playlistProvider.playlist[index].songName,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  playlistProvider.playlist[index].artistName,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 13,
                                    color: Colors.grey,
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
              ),
              // BPM number
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                padding: EdgeInsets.all(3),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(41, 128, 128, 128),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                ),
                // TODO Make BPM tappable with GestureDetector (https://api.flutter.dev/flutter/widgets/GestureDetector-class.html)
                child: InkWell(
                  onTap: () async {
                    // Show dialog to edit BPM
                    await _showEditBPMDialog(index);
                  },
                  child: Text(
                    playlistProvider.playlist[index].BPM.toInt().toString(), // Remove decimals
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 19,
                      // color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this method to the _PlaylistPage class
  Future<void> _showEditBPMDialog(int songIndex) async {
    TextEditingController bpmController = TextEditingController(
      text: playlistProvider.playlist[songIndex].BPM.toString(),
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit BPM'),
          content: TextField(
            controller: bpmController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Validate input (ensure it's a number)
                double? newBPM = double.tryParse(bpmController.text);
                if (newBPM != null) {
                  // Update BPM in the playlist
                  playlistProvider.playlist[songIndex].BPM = newBPM;
                  playlistProvider.notifyListeners(); // Notify listeners
                  Navigator.of(context).pop();
                } else {
                  // Show error message or handle invalid input
                  // ...
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(int songIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User can't ignore this dialog!
      builder: (BuildContext context) {
        // Check if the playlist is empty or the index is invalid
        if (playlistProvider.playlist.isEmpty || songIndex >= playlistProvider.playlist.length) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No song to delete.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Delete Song'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Are you sure you want to delete '${playlistProvider.playlist[songIndex].songName}'?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  // Remove the song from the playlist
                  playlistProvider.removeSong(songIndex);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

}
