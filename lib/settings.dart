import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:mladez_zpevnik/config.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.preferences, this.config, this.saveSettings})
      : super(key: key);
  final SharedPreferences preferences;
  final Config config;
  final saveSettings;

  @override
  _SettingsState createState() => _SettingsState(
      preferences: this.preferences,
      config: this.config,
      saveSettings: this.saveSettings);
}

class _SettingsState extends State<Settings> {
  SharedPreferences preferences;
  Config config;
  final snackBar = SnackBar(
      content: Row(
    children: <Widget>[Text('Úspěšně uloženo')],
    mainAxisAlignment: MainAxisAlignment.center,
  ));
  var saveSettings;

  @override
  void initState() {
    _textSize = config.textSize ?? 14;
    _darkMode = config.darkMode ?? false;
    _red = config.primary.red ?? 33;
    _blue = config.primary.blue ?? 243;
    _green = config.primary.green ?? 150;
    _redL = config.secondary.red ?? 46;
    _blueL = config.secondary.blue ?? 50;
    _greenL = config.secondary.green ?? 125;
    _showChords = config.showChords ?? false;
    super.initState();
  }

  _SettingsState({this.preferences, this.config, this.saveSettings});

  int _textSize;
  bool _darkMode;
  int _red;
  int _green;
  int _blue;
  int _redL;
  int _greenL;
  int _blueL;
  bool _bar = false;
  bool _showChords;

  @override
  Widget build(BuildContext context) {
//    TextStyle textStyle =
//        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    return Scaffold(
//        backgroundColor: config.darkMode ? Colors.black87 : Colors.white,
        appBar: AppBar(title: Text('Nastavení')),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Velikost obsahu',
                            style: TextStyle(fontSize: _textSize.toDouble()),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: FluidSlider(
                            value: _textSize.toDouble(),
                            onChanged: (double newValue) {
                              setState(() {
                                _textSize = newValue.truncate();
                              });
                            },
                            min: 6.0,
                            max: 32.0,
                          )),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Pozadí aplikace',
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Světlé',
                          ),
                          Switch(
                            value: _darkMode,
                            activeTrackColor:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),
                          Text(
                            'Tmavé',
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Ukázat akordy',
                          )),
                      Switch(
                        value: _showChords,
                        activeTrackColor:
                            Theme.of(context).primaryColor.withOpacity(0.6),
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (bool value) {
                          setState(() {
                            _showChords = value;
                          });
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Výběr barev aplikací',
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Primární',
                          ),
                          Switch(
                            value: _bar,
                            inactiveThumbColor:
                                Color.fromRGBO(_red, _green, _blue, 1.0),
                            inactiveTrackColor:
                                Color.fromRGBO(_red, _green, _blue, 0.55),
                            activeTrackColor:
                                Color.fromRGBO(_redL, _greenL, _blueL, 0.55),
                            activeColor:
                                Color.fromRGBO(_redL, _greenL, _blueL, 1.0),
                            onChanged: (bool value) {
                              setState(() {
                                _bar = value;
                              });
                            },
                          ),
                          Text(
                            'Sekundární',
                          ),
                        ],
                      ),
                      FluidSlider(
                        valueTextStyle: TextStyle(color: Colors.transparent),
                        sliderColor: Colors.red,
                        value: (_bar ? _redL : _red).toDouble(),
                        onChanged: (double newValue) {
                          setState(() {
                            if (_bar) {
                              _redL = newValue.truncate();
                            } else {
                              _red = newValue.truncate();
                            }
                          });
                        },
                        min: 0.0,
                        max: 255.0,
                        start: Center(),
                        end: Center(),
                      ),
                      FluidSlider(
                        valueTextStyle: TextStyle(color: Colors.transparent),
                        sliderColor: Colors.green,
                        value: (_bar ? _greenL : _green).toDouble(),
                        onChanged: (double newValue) {
                          setState(() {
                            if (_bar) {
                              _greenL = newValue.truncate();
                            } else {
                              _green = newValue.truncate();
                            }
                          });
                        },
                        min: 0.0,
                        max: 255.0,
                        start: Center(),
                        end: Center(),
                      ),
                      FluidSlider(
                        valueTextStyle: TextStyle(color: Colors.transparent),
                        sliderColor: Colors.blue,
                        value: (_bar ? _blueL : _blue).toDouble(),
                        onChanged: (double newValue) {
                          setState(() {
                            if (_bar) {
                              _blueL = newValue.truncate();
                            } else {
                              _blue = newValue.truncate();
                            }
                          });
                        },
                        min: 0.0,
                        max: 255.0,
                        start: Center(),
                        end: Center(),
                      ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: RaisedButton(
                            color: _bar
                                ? Color.fromRGBO(_redL, _greenL, _blueL, 1.0)
                                : Color.fromRGBO(_red, _green, _blue, 1.0),
                            child: Text(
                              'Uložit',
//                              style: TextStyle(
//                                  color: config.darkMode
//                                      ? Colors.black
//                                      : Colors.white),
                            ),
                            onPressed: () {
                              Config newConfig = Config(
                                  Color.fromRGBO(_red, _green, _blue, 1.0),
                                  Color.fromRGBO(_redL, _greenL, _blueL, 1.0),
                                  _darkMode,
                                  config.songFontSize,
                                  _textSize,
                                  _showChords);
                              saveSettings(newConfig);
                              preferences.setString(
                                  'config', jsonEncode(newConfig));
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                          )),
                    ])))));
  }
}
