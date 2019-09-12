import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/songDisplay.dart';
import 'package:mladez_zpevnik/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberSelect extends StatefulWidget {
  NumberSelect(
      {Key key,
      this.songs,
      this.preferences,
      this.showChords,
      this.saveSettings})
      : super(key: key);
  final List<Song> songs;
  final SharedPreferences preferences;
  final bool showChords;
  final saveSettings;

  @override
  _NumberSelectState createState() => _NumberSelectState(
      songs: this.songs,
      preferences: this.preferences,
      showChords: this.showChords,
      saveSettings: this.saveSettings);
}

class _NumberSelectState extends State<NumberSelect> {
  _NumberSelectState(
      {this.songs,
      this.preferences,
      this.songFontSize,
      this.showChords,
      this.saveSettings});

  double songFontSize;
  bool showChords;
  List<Song> songs;
  SharedPreferences preferences;
  Config config;
  var saveSettings;
  TextEditingController fieldController = TextEditingController();

  openSong(String number) {
    int parsedNumber;
    try {
      parsedNumber = int.parse(number);
    } catch (e) {
      Navigator.pop(context);
    }
    setState(() {
      fieldController.text = "";
      if (!parsedNumber.isNaN) {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return SongDisplay(
                song: songs[parsedNumber - (parsedNumber < 198 ? 1 : 3)],
                preferences: preferences,
                showChords: showChords,
                saveSettings: saveSettings);
          },
        ));
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = DynamicTheme.of(context).data.primaryColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: primary, width: 3.0)),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          counterText: "", border: InputBorder.none),
                      cursorColor: primary,
                      controller: fieldController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      onSubmitted: openSong,
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      onChanged: (String data) {
                        int number;
                        try {
                          number = int.parse(data);
                        } catch (e) {
                          fieldController.text =
                              data.substring(0, data.length - 1);
                        }
                        if (number > 205 ||
                            number < 1 ||
                            (number < 200 && number > 197)) {
                          fieldController.text =
                              data.substring(0, data.length - 1);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          color: primary,
                          textColor: Colors.white,
                          child: Text("Otevřít"),
                          onPressed: () {
                            openSong(fieldController.text);
                          },
                        ),
                        RaisedButton(
                          color: primary,
                          textColor: Colors.white,
                          child: Text("Zavřít"),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    )
                  ],
                )))
      ],
    );
  }
}
