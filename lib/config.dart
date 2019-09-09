import 'dart:convert' show json;
import 'dart:ui';

class Config {
  Color primary;
  Color secondary;
  int songFontSize;
  int textSize;
  bool showChords;

  Config(this.primary, this.secondary, this.songFontSize, this.textSize,
      this.showChords);

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
      'songFontSize': songFontSize,
      'textSize': textSize,
      'showChords': showChords
    };
  }

  String toString() {
    return json.encode(this);
  }
}
