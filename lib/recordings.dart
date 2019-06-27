import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class Recordings extends StatefulWidget {
  Recordings({Key key, this.preferences, this.config}) : super(key: key);
  final SharedPreferences preferences;
  final Config config;
  @override
  _RecordingsState createState() =>
      _RecordingsState(preferences: this.preferences, config: this.config);
}

class Event {}

class _RecordingsState extends State<Recordings> {
  SharedPreferences preferences;
  Config config;

  _RecordingsState({this.preferences, this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nahrávky'),
        ),
        body: Center(
            child: RaisedButton(
                onPressed: () {
                  FilePicker.getFilePath(type: FileType.AUDIO).then((value) {
                    debugPrint(value.toString());
                  });
                },
                child: Text('Vybrat soubor'))));
  }
}
