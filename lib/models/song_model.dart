import 'package:flutter/material.dart';

// Thanks https://youtu.be/D4nhaszNW4o?t=901
class SongModel {
  bool isSelected;
  AssetImage coverImage;
  String sourceFilePath;  // It's of type string because we need its path
  String songName;
  String artistName;
  double BPM;

  // Constructor
  SongModel({
    required this.isSelected,
    required this.coverImage,
    required this.sourceFilePath,
    required this.songName,
    required this.artistName,
    required this.BPM,
  });

  static List<SongModel> getSongs() { // With static this method can be accessed without instantiating the class
    List<SongModel> songs = [];

    songs.add(
      SongModel(
        isSelected: true,
        coverImage: AssetImage("assets/images/music-icon.png"),
        sourceFilePath: Uri.parse("asset:///assets/audio-example.mp3").toString(),
        songName: "Song 1",
        artistName: "Artist 1",
        BPM: 135
      )
    );
    songs.add(
      SongModel(
        isSelected: false,
        coverImage: AssetImage("assets/images/music-icon.png"),
        sourceFilePath: Uri.parse("asset:///assets/audio-example.mp3").toString(),
        songName: "Song 2",
        artistName: "Artist 2",
        BPM: 90
      )
    );
    songs.add(
      SongModel(
        isSelected: true,
        coverImage: AssetImage("assets/images/music-icon.png"),
        sourceFilePath: Uri.parse("asset:///assets/audio-example.mp3").toString(),
        songName: "Song 3",
        artistName: "Artist 3",
        BPM: 122
      )
    );
    // songs.add( ...

    return songs;
  }
}

