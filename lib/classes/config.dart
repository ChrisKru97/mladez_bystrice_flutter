import 'dart:convert' show jsonEncode;
import 'package:flutter/material.dart' show Colors, Color, MaterialColor;

class Config {
  Config(
      {this.primary = Colors.blue,
      this.secondary = const Color(0xFF2E7D32),
      this.songFontSize = 22,
      this.showChords = false,
      this.darkMode = false});

  MaterialColor primary;
  Color secondary;
  int songFontSize;
  bool showChords;
  bool darkMode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'primary': primary.toString(),
        'secondary': secondary.toString(),
        'songFontSize': songFontSize,
        'showChords': showChords,
        'darkMode': darkMode
      };

  @override
  String toString() => jsonEncode(this);
}
