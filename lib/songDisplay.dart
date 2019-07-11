import 'dart:convert';

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
    return Scaffold(
//          backgroundColor: config.darkMode ? Colors.black26 : Colors.white,
      appBar: AppBar(
        backgroundColor: config.primary,
        title: Text(song.number.toString() + '. ' + song.name),
      ),
      body: SingleChildScrollView(
          child: GestureDetector(
              onScaleStart: (ScaleStartDetails scaleDetails) => setState(() {
//                        debugPrint(scaleDetails.toString());
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
//                    config.darkMode,
                    newFontSize,
                    config.textSize,
                    config.showChords);
                saveSettings(newConfig);
                preferences.setString('config', jsonEncode(newConfig));
              },
              child: Center(
                  child: Text(
                song.song,
                style: TextStyle(fontSize: _songFontSize.toDouble()),
                textAlign: TextAlign.center,
              ))),
          padding: EdgeInsets.all(5.0)),
    );
  }
}
