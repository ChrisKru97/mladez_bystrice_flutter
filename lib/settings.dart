import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
//    _darkMode = config.darkMode ?? false;
    _primary = config.primary ?? Colors.blue;
    _secondary = config.secondary ?? Colors.green[800];
    _showChords = config.showChords ?? false;
    super.initState();
  }

  _SettingsState({this.preferences, this.config, this.saveSettings});

  int _textSize;
//  bool _darkMode;
  Color _primary;
  Color _secondary;
  bool _showChords;

  _selectColor(parentContext, secondary) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      color: secondary
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).primaryColor,
                      width: 3.0)),
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(children: <Widget>[
                    MaterialColorPicker(
                      selectedColor: secondary ? _secondary : _primary,
                      onColorChange: (Color color) {
                        setState(() {
                          if (secondary) {
                            _secondary = color;
                          } else {
                            _primary = color;
                          }
                        });
                      },
                    ),
                    RaisedButton(
                      color: secondary ? _secondary : _primary,
                      textColor: Colors.white,
                      child: Text("Zavřít"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ])));
        });
  }

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
//                      Padding(
//                          padding: EdgeInsets.all(15.0),
//                          child: Text(
//                            'Pozadí aplikace',
//                          )),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: <Widget>[
//                          Text(
//                            'Světlé',
//                          ),
//                          Switch(
//                            value: _darkMode,
//                            activeTrackColor:
//                                Theme.of(context).primaryColor.withOpacity(0.6),
//                            activeColor: Theme.of(context).primaryColor,
//                            onChanged: (bool value) {
//                              setState(() {
//                                if (value) {
//                                  _darkMode = true;
//                                  _red = 222;
//                                  _blue = 12;
//                                  _green = 105;
//                                  _redL = 209;
//                                  _blueL = 215;
//                                  _greenL = 130;
//                                } else {
//                                  _darkMode = false;
//                                  _red = 33;
//                                  _blue = 243;
//                                  _green = 150;
//                                  _redL = 46;
//                                  _blueL = 50;
//                                  _greenL = 125;
//                                }
//                              });
//                            },
//                          ),
//                          Text(
//                            'Tmavé',
//                          ),
//                        ],
//                      ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Ukázat akordy',
                            style: TextStyle(fontSize: 22),
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
                            style: TextStyle(fontSize: 22),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Primární barva"),
                            RaisedButton(
                              color: _primary,
                              child: Text("Vybrat"),
                              textColor: Colors.white,
                              onPressed: () {
                                _selectColor(context, false);
                              },
                            )
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Sekundární barva"),
                            RaisedButton(
                              color: _primary,
                              textColor: Colors.white,
                              child: Text("Vybrat"),
                              onPressed: () {
                                _selectColor(context, true);
                              },
                            )
                          ]),
//                      FluidSlider(
//                        valueTextStyle: TextStyle(color: Colors.transparent),
//                        sliderColor: Colors.red,
//                        value: (_bar ? _redL : _red).toDouble(),
//                        onChanged: (double newValue) {
//                          setState(() {
//                            if (_bar) {
//                              _redL = newValue.truncate();
//                            } else {
//                              _red = newValue.truncate();
//                            }
//                          });
//                        },
//                        min: 0.0,
//                        max: 255.0,
//                        start: Center(),
//                        end: Center(),
//                      ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: RaisedButton(
                            color: _primary,
                            textColor: Colors.white,
                            child: Text(
                              'Uložit',
//                              style: TextStyle(
//                                  color: config.darkMode
//                                      ? Colors.black
//                                      : Colors.white),
                            ),
                            onPressed: () {
                              Config newConfig = Config(
                                  _primary,
                                  _secondary,
//                                  _darkMode,
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
