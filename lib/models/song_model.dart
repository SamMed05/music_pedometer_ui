import 'package:flutter/material.dart';

// Thanks https://youtu.be/D4nhaszNW4o?t=901
class SongModel {
  bool isSelected;
  String songName;
  String artistName;
  String coverImage; // It's of type string because we need its path
  String audioPath; // It's of type string because we need its path
  double BPM;

  // Constructor
  SongModel({
    required this.isSelected,
    required this.songName,
    required this.artistName,
    required this.coverImage,
    required this.audioPath,
    required this.BPM,
  });
}
