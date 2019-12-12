import 'dart:convert' show jsonEncode;
import 'package:flutter/material.dart' show Colors, Color, MaterialColor;

class Config {
  Config(
      {this.primary = Colors.blue,
      this.secondary = const Color(0xFF2E7D32),
      this.songFontSize = 22,
      this.showChords = false,
      this.darkMode = false,
      this.alignCenter = false,
      this.skipAnimation = false});

  MaterialColor primary;
  Color secondary;
  double songFontSize;
  bool showChords;
  bool darkMode;
  bool alignCenter;
  bool skipAnimation;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'primary': primary.toString(),
        'secondary': secondary.toString(),
        'songFontSize': songFontSize,
        'showChords': showChords,
        'darkMode': darkMode,
        'alignCenter': alignCenter,
      };

  @override
  String toString() => jsonEncode(this);
}
