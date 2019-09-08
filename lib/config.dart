import 'dart:convert' show json;
import 'dart:ui';

class Config {
  final Color primary;
  final Color secondary;
  final bool darkMode;
  final int songFontSize;
  final int textSize;
  final bool showChords;

  Config(this.primary, this.secondary, this.darkMode, this.songFontSize,
      this.textSize, this.showChords);

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
      'darkMode': darkMode,
      'songFontSize': songFontSize,
      'textSize': textSize,
      'showChords': showChords
    };
  }

  String toString() {
    return json.encode(this);
  }
}
