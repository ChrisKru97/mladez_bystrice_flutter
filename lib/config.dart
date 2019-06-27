import 'dart:convert' show json;
import 'dart:ui';

class Config {
  final Color primary;
  final Color secondary;
//  final bool darkMode;
  final int songFontSize;
  final int textSize;

  Config(
      this.primary,
      this.secondary,
//      this.darkMode,
      this.songFontSize,
      this.textSize);

  toJson() {
    return {
      'primary': {
        'green': primary.green,
        'red': primary.red,
        'blue': primary.blue
      },
      'secondary': {
        'green': secondary.green,
        'red': secondary.red,
        'blue': secondary.blue
      },
//      'darkMode': darkMode,
      'songFontSize': songFontSize,
      'textSize': textSize,
    };
  }

  String toString() {
    return json.encode(this);
  }
}
