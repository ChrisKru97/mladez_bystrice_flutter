import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongDisplay extends StatefulWidget {
  SongDisplay(
      {Key key,
      this.song,
      this.preferences,
      this.songFontSize,
      this.showChords,
      this.saveSettings})
      : super(key: key);
  final Song song;
  final SharedPreferences preferences;
  final double songFontSize;
  final bool showChords;
  final saveSettings;

  @override
  _SongDisplayState createState() => _SongDisplayState(
      song: this.song,
      preferences: this.preferences,
      songFontSize: this.songFontSize,
      showChords: this.showChords,
      saveSettings: this.saveSettings);
}

class _SongDisplayState extends State<SongDisplay> {
  _SongDisplayState(
      {this.song,
      this.preferences,
      this.songFontSize,
      this.showChords,
      this.saveSettings});

  int _songFontSize;
  int _previousFontSize;

  Song song;
  SharedPreferences preferences;
  double songFontSize;
  bool showChords;
  var saveSettings;

  @override
  void initState() {
    _songFontSize = songFontSize.toInt() ?? 28;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: DynamicTheme.of(context).data.primaryColor,
      title: Text(song.number.toString() + '. ' + song.name),
    );
    return Scaffold(
        appBar: appBar,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (ScaleStartDetails scaleDetails) => setState(() {
            _previousFontSize = _songFontSize;
          }),
          onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
            int newFontSize = (_previousFontSize * scaleDetails.scale).round();
            setState(() {
              if (newFontSize >= 40) {
                _songFontSize = 40;
              } else if (newFontSize <= 12) {
                _songFontSize = 12;
              } else {
                _songFontSize = newFontSize;
              }
            });
            saveSettings('songFontSize', newFontSize);
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        appBar.preferredSize.height),
                child: Center(
                    child: Text(
                  song.song,
                  style: TextStyle(fontSize: _songFontSize.toDouble()),
                  textAlign: TextAlign.center,
                ))),
          ),
        ));
  }
}
