import 'dart:convert';
import 'package:dynamic_theme/dynamic_theme.dart';
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
    _darkMode = DynamicTheme.of(context).data.brightness == Brightness.dark;
    _primary = config.primary ?? Colors.blue;
    _secondary = config.secondary ?? Colors.green[800];
    _showChords = config.showChords ?? false;
    super.initState();
  }

  _SettingsState({this.preferences, this.config, this.saveSettings});

  int _textSize;
  bool _darkMode;
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
                          ? DynamicTheme.of(parentContext)
                              .data
                              .secondaryHeaderColor
                          : DynamicTheme.of(parentContext).data.primaryColor,
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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: DynamicTheme.of(context).data.primaryColor,
            title: Text('Nastavení')),
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
                            sliderColor: _primary,
                            value: _textSize.toDouble(),
                            labelsTextStyle: TextStyle(
                                color: DynamicTheme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white),
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
                          child: Text('Pozadí aplikace',
                              style: TextStyle(fontSize: 22))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Světlé',
                          ),
                          Switch(
                            value: _darkMode,
                            activeTrackColor: _primary.withOpacity(0.6),
                            activeColor: _primary,
                            onChanged: (bool value) {
                              setState(() {
                                if (value) {
                                  _darkMode = true;
                                } else {
                                  _darkMode = false;
                                }
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
                            style: TextStyle(fontSize: 22),
                          )),
                      Switch(
                        value: _showChords,
                        activeTrackColor: _primary.withOpacity(0.6),
                        activeColor: _primary,
                        onChanged: (bool value) {
                          setState(() {
                            _showChords = value;
                          });
                        },
                      ),
                      if (!_darkMode)
                        Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Výběr barev aplikací',
                              style: TextStyle(fontSize: 22),
                            )),
                      if (!_darkMode)
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
                      if (!_darkMode)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Sekundární barva"),
                              RaisedButton(
                                color: _secondary,
                                textColor: Colors.white,
                                child: Text("Vybrat"),
                                onPressed: () {
                                  _selectColor(context, true);
                                },
                              )
                            ]),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: RaisedButton(
                            color: _primary,
                            textColor: Colors.white,
                            child: Text(
                              'Uložit',
                            ),
                            onPressed: () {
                              Config newConfig = Config(_primary, _secondary,
                                  config.songFontSize, _textSize, _showChords);
                              if (_darkMode) {
                                DynamicTheme.of(context).setThemeData(ThemeData(
                                    primaryColor: _primary,
                                    textTheme: TextTheme(
                                        display3: TextStyle(
                                            fontSize: _textSize.toDouble() + 6,
                                            fontWeight: FontWeight.bold),
                                        display4: TextStyle(
                                            fontSize: _textSize.toDouble())),
                                    secondaryHeaderColor: _secondary));
                                DynamicTheme.of(context)
                                    .setBrightness(Brightness.dark);
                              } else {
                                DynamicTheme.of(context)
                                    .setBrightness(Brightness.light);
                                DynamicTheme.of(context).setThemeData(ThemeData(
                                    primaryColor: _primary,
                                    textTheme: TextTheme(
                                        display3: TextStyle(
                                            fontSize: _textSize.toDouble() + 6,
                                            fontWeight: FontWeight.bold),
                                        display4: TextStyle(
                                            fontSize: _textSize.toDouble())),
                                    secondaryHeaderColor: _secondary));
                              }
                              saveSettings('config', newConfig);
                              preferences.setString(
                                  'config', jsonEncode(newConfig));
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                          )),
                    ])))));
  }
}
