import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:mladez_zpevnik/classes/config.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.config, this.saveSettings}) : super(key: key);
  final Config config;
  final saveSettings;

  @override
  _SettingsState createState() =>
      _SettingsState(config: this.config, saveSettings: this.saveSettings);
}

class _SettingsState extends State<Settings> {
  Config config;
  final snackBar = SnackBar(
      content: Row(
    children: <Widget>[Text('Úspěšně uloženo')],
    mainAxisAlignment: MainAxisAlignment.center,
  ));
  var saveSettings;

  @override
  void initState() {
    _darkMode = config.darkMode ?? false;
    _primary = config.primary ?? Colors.blue;
    _secondary = config.secondary ?? Colors.green[800];
    _showChords = config.showChords ?? false;
    super.initState();
  }

  _SettingsState({this.config, this.saveSettings});

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
                  side: BorderSide(width: 3.0)),
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(children: <Widget>[
                    MaterialColorPicker(
                      selectedColor: _primary,
                      onColorChange: (Color color) {
                        setState(() {
                          _secondary = color;
                        });
                      },
                    ),
                    RaisedButton(
                      color: _primary,
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
        appBar: AppBar(title: Text('Nastavení')),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
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
                              Config newConfig = Config(
                                  primary: Colors.blue,
                                  secondary: _secondary,
                                  songFontSize: config.songFontSize,
                                  showChords: _showChords);
                              saveSettings(newConfig);
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                          )),
                    ])))));
  }
}
