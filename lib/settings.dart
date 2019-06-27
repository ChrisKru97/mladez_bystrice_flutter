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

  _SettingsState({this.preferences, this.config, this.saveSettings});

  int _textSize;
  int _songFontSize;
  bool _darkMode;
  int _red;
  int _green;
  int _blue;
  int _redL;
  int _greenL;
  int _blueL;
  bool _bar = false;
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
                            'Velikost textu písně',
                            style: TextStyle(
                                fontSize: (_songFontSize != null
                                        ? _songFontSize
                                        : config.songFontSize)
                                    .toDouble()),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: FluidSlider(
                            value: (_songFontSize != null
                                    ? _songFontSize
                                    : config.songFontSize)
                                .toDouble(),
                            onChanged: (double newValue) {
                              setState(() {
                                _songFontSize = newValue.truncate();
                              });
                            },
                            min: 10.0,
                            max: 40.0,
                          )),
                      Divider(),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Velikost obsahu',
                            style: TextStyle(
                                fontSize: (_textSize != null
                                        ? _textSize
                                        : config.textSize)
                                    .toDouble()),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: FluidSlider(
                            sliderColor: config.primary,
                            thumbColor: config.primary,
                            value: (_textSize != null
                                    ? _textSize
                                    : config.textSize)
                                .toDouble(),
                            onChanged: (double newValue) {
                              setState(() {
                                _textSize = newValue.truncate();
                              });
                            },
                            min: 10.0,
                            max: 40.0,
                          )),
                      Divider(),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Pozadí aplikace',
//                            style: textStyle,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Světlé',
//                            style: textStyle,
                          ),
                          Switch(
                            value: _darkMode ?? config.darkMode,
                            inactiveThumbColor: Colors.blue,
                            inactiveTrackColor: Colors.blue[300],
                            activeTrackColor: Colors.blue[300],
                            activeColor: Colors.blue,
                            onChanged: (bool value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),
                          Text(
                            'Tmavé',
//                            style: textStyle,
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Výběr barev aplikací',
//                            style: textStyle,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Primární',
//                            style: textStyle,
                          ),
                          Switch(
                            value: _bar,
                            inactiveThumbColor: Color.fromRGBO(
                                _red ?? config.primary.red,
                                _green ?? config.primary.green,
                                _blue ?? config.primary.blue,
                                1.0),
                            inactiveTrackColor: Color.fromRGBO(
                                _red ?? config.primary.red,
                                _green ?? config.primary.green,
                                _blue ?? config.primary.blue,
                                0.55),
                            activeTrackColor: Color.fromRGBO(
                                _redL ?? config.secondary.red,
                                _greenL ?? config.secondary.green,
                                _blueL ?? config.secondary.blue,
                                0.55),
                            activeColor: Color.fromRGBO(
                                _redL ?? config.secondary.red,
                                _greenL ?? config.secondary.green,
                                _blueL ?? config.secondary.blue,
                                1.0),
                            onChanged: (bool value) {
                              setState(() {
                                _bar = value;
                              });
                            },
                          ),
                          Text(
                            'Sekundární',
//                            style: textStyle,
                          ),
                        ],
                      ),
                      FluidSlider(
                        valueTextStyle: TextStyle(color: Colors.transparent),
                        sliderColor: Colors.red,
                        value: (_bar
                                ? _redL ?? config.secondary.red
                                : _red ?? config.primary.red)
                            .toDouble(),
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
                        value: (_bar
                                ? _greenL ?? config.secondary.green
                                : _green ?? config.primary.green)
                            .toDouble(),
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
                        value: (_bar
                                ? _blueL ?? config.secondary.blue
                                : _blue ?? config.primary.blue)
                            .toDouble(),
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
                                ? Color.fromRGBO(
                                    _redL ?? config.secondary.red,
                                    _greenL ?? config.secondary.green,
                                    _blueL ?? config.secondary.blue,
                                    1.0)
                                : Color.fromRGBO(
                                    _red ?? config.primary.red,
                                    _green ?? config.primary.green,
                                    _blue ?? config.primary.blue,
                                    1.0),
                            child: Text(
                              'Uložit',
//                              style: TextStyle(
//                                  color: config.darkMode
//                                      ? Colors.black
//                                      : Colors.white),
                            ),
                            onPressed: () {
                              Config config = Config(
                                  Color.fromRGBO(_red, _green, _blue, 1.0),
                                  Color.fromRGBO(_redL, _greenL, _blueL, 1.0),
                                  _darkMode,
                                  _songFontSize,
                                  _textSize);
                              saveSettings(config);
                              preferences?.setString(
                                  'config', config.toString());
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                          )),
                    ])))));
  }
}
