import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/songDisplay.dart';
import 'package:mladez_zpevnik/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberSelect extends StatefulWidget {
  NumberSelect(
      {Key key, this.songs, this.preferences, this.config, this.saveSettings})
      : super(key: key);
  final List<Song> songs;
  final SharedPreferences preferences;
  final Config config;
  final saveSettings;

  @override
  _NumberSelectState createState() => _NumberSelectState(
      songs: this.songs,
      preferences: this.preferences,
      config: this.config,
      saveSettings: this.saveSettings);
}

class _NumberSelectState extends State<NumberSelect> {
  _NumberSelectState(
      {this.songs, this.preferences, this.config, this.saveSettings});

  List<Song> songs;
  SharedPreferences preferences;
  Config config;
  var saveSettings;

  String _number = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side:
                BorderSide(color: Theme.of(context).primaryColor, width: 3.0)),
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(_number, style: TextStyle(fontSize: 22)),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("1"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "1";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("2"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "2";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("3"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "3";
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("4"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "4";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("5"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "5";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("6"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "6";
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("7"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "7";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("8"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "8";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("9"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "9";
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("0"),
                      onPressed: () {
                        setState(() {
                          _number = _number + "0";
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Icon(Icons.backspace),
                      onPressed: () {
                        setState(() {
                          _number = _number.substring(0, _number.length - 1);
                        });
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Icon(Icons.subdirectory_arrow_left),
                      onPressed: () {
                        int number;
                        try {
                          number = int.parse(_number);
                        } catch (e) {
                          Navigator.pop(context);
                        }
                        setState(() {
                          _number = "";
                          if (number < 206 &&
                              number > 0 &&
                              (number > 199 || number < 198)) {
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return SongDisplay(
                                    song:
                                        songs[number - (number < 198 ? 1 : 3)],
                                    preferences: preferences,
                                    config: config,
                                    saveSettings: saveSettings);
                              },
                            ));
                          } else {
                            setState(() {
                              _number = "";
                            });
                          }
                        });
                      },
                    )
                  ],
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Zavřít"),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            )));
  }
}
