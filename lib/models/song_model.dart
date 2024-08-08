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

  // // Constructor to create a SongModel from a JSON map
  // SongModel.fromJson(Map<String, dynamic> json) {
  //   isSelected = json['isSelected'] ?? true; // Provide default value since non-nullable properties  
  //   songName = json['songName'] ?? '';
  //   artistName = json['artistName'] ?? '';
  //   coverImage = json['coverImage'] ?? '';
  //   audioPath = json['audioPath'] ?? '';
  //   BPM = json['BPM']?.toDouble() ?? 0.0; // Provide default value (0.0) and convert to double
  // }
  // Constructor to create a SongModel from a JSON map
  SongModel.fromJson(Map<String, dynamic> json) 
    : isSelected = json['isSelected'] ?? true,
      songName = json['songName'] ?? '',
      artistName = json['artistName'] ?? '',
      coverImage = json['coverImage'] ?? '',
      audioPath = json['audioPath'] ?? '',
      BPM = json['BPM']?.toDouble() ?? 0.0; 

  // Method to convert a SongModel to a JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      'isSelected': isSelected,
      'songName': songName,
      'artistName': artistName,
      'coverImage': coverImage,
      'audioPath': audioPath,
      'BPM': BPM,
    };
  }
}
