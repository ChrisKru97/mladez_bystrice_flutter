import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/classes/song.dart';

class SongDisplay extends StatefulWidget {
  SongDisplay({Key key, this.song, this.showChords, this.saveSettings})
      : super(key: key);
  final Song song;
  final bool showChords;
  final saveSettings;

  @override
  _SongDisplayState createState() => _SongDisplayState(
      song: this.song,
      showChords: this.showChords,
      saveSettings: this.saveSettings);
}

class _SongDisplayState extends State<SongDisplay> {
  _SongDisplayState({this.song, this.showChords, this.saveSettings});

  int _songFontSize;
  int _previousFontSize;

  Song song;
  bool showChords;
  var saveSettings;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
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
            if (newFontSize >= 40) {
              newFontSize = 40;
            } else if (newFontSize <= 12) {
              newFontSize = 12;
            }
            setState(() {
              _songFontSize = newFontSize;
            });
            saveSettings(newFontSize);
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        appBar.preferredSize.height,
                    minWidth: MediaQuery.of(context).size.width),
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
