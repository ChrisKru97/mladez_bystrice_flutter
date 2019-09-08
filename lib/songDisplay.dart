import 'dart:convert';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongDisplay extends StatefulWidget {
  SongDisplay(
      {Key key, this.song, this.preferences, this.config, this.saveSettings})
      : super(key: key);
  final Song song;
  final SharedPreferences preferences;
  final Config config;
  final saveSettings;

  @override
  _SongDisplayState createState() => _SongDisplayState(
      song: this.song,
      preferences: this.preferences,
      config: this.config,
      saveSettings: this.saveSettings);
}

class _SongDisplayState extends State<SongDisplay> {
  _SongDisplayState(
      {this.song, this.preferences, this.config, this.saveSettings});

  int _songFontSize;
  int _previousFontSize;

  Song song;
  SharedPreferences preferences;
  Config config;
  var saveSettings;

  @override
  void initState() {
    _songFontSize = config.songFontSize ?? 28;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Color> primary = {
      50: config.primary.withOpacity(.1),
      100: config.primary.withOpacity(.2),
      200: config.primary.withOpacity(.3),
      300: config.primary.withOpacity(.4),
      400: config.primary.withOpacity(.5),
      500: config.primary.withOpacity(.6),
      600: config.primary.withOpacity(.7),
      700: config.primary.withOpacity(.8),
      800: config.primary.withOpacity(.9),
      900: config.primary.withOpacity(1),
    };
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
            primarySwatch: MaterialColor(config.primary.value, primary),
            brightness: brightness,
            secondaryHeaderColor: config.secondary),
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.primaryColor,
              title: Text(song.number.toString() + '. ' + song.name),
            ),
            body: GestureDetector(
              onScaleStart: (ScaleStartDetails scaleDetails) => setState(() {
                _previousFontSize = _songFontSize;
              }),
              onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
                int newFontSize =
                    (_previousFontSize * scaleDetails.scale).round();
                setState(() {
                  if (newFontSize >= 40) {
                    _songFontSize = 40;
                  } else if (newFontSize <= 12) {
                    _songFontSize = 12;
                  } else {
                    _songFontSize = newFontSize;
                  }
                });
                Config newConfig = Config(
                    config.primary,
                    config.secondary,
                    config.darkMode,
                    newFontSize,
                    config.textSize,
                    config.showChords);
                saveSettings(newConfig);
                preferences.setString('config', jsonEncode(newConfig));
              },
              child: SingleChildScrollView(
                  child: Center(
                      child: Text(
                    song.song,
                    style: TextStyle(fontSize: _songFontSize.toDouble()),
                    textAlign: TextAlign.center,
                  )),
                  padding: EdgeInsets.all(5.0)),
            ),
          );
        });
  }
}
