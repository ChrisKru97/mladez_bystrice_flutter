import 'dart:convert' show json;
//import 'dart:ui';

class Config {
//  final Color primary;
//  final Color secondary;
//  final bool darkMode;
  final int songFontSize;
//  final int textSize;

  Config(
//      this.primary, this.secondary, this.darkMode,
    this.songFontSize,
//      this.textSize
  );

  toJson() {
    return {
      'songFontSize': songFontSize,
    };
  }

  String toString() {
    return json.encode(this);
  }
}
