import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/social.dart';
import 'package:mladez_zpevnik/songs.dart';
import 'package:mladez_zpevnik/settings.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:mladez_zpevnik/recordings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mládež Bystřice',
      theme: ThemeData(
          primarySwatch: Colors.blue, secondaryHeaderColor: Colors.green[800]),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  SharedPreferences _preferences;
  Config _config = Config(Colors.blue, Colors.green[800], false, 28, 14, false);

  _saveSettings(Config config) {
    this.setState(() {
      _config = config;
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      String configString = value.getString('config') ?? '';
      if (configString != '') {
        var data = jsonDecode(configString);
        setState(() {
          _config = Config(
              Color.fromRGBO(data['primary']['red'], data['primary']['green'],
                  data['primary']['blue'], 1.0),
              Color.fromRGBO(data['secondary']['red'],
                  data['secondary']['green'], data['secondary']['blue'], 1.0),
              data['darkMode'],
              data['songFontSize'],
              data['textSize'],
              data['showChords']);
          _preferences = value;
        });
      } else {
        setState(() {
          _preferences = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_preferences == null) {
      return Scaffold(
        body: SpinKitWave(color: _config.secondary),
        backgroundColor: Colors.black12,
      );
    }
    Widget myWidget;
    switch (_selectedIndex) {
      case 0:
        myWidget = Social(
          preferences: _preferences,
          config: _config,
        );
        break;
//      case 1:
//        myWidget = Recordings(preferences: _preferences, config: _config);
//        break;
      case 1:
        myWidget = SongBook(
          preferences: _preferences,
          config: _config,
          saveSettings: _saveSettings,
        );
        break;
      case 2:
        myWidget = Settings(
            preferences: _preferences,
            config: _config,
            saveSettings: _saveSettings);
        break;
      default:
        myWidget = Center();
    }
    return Theme(
        data: Theme.of(context).copyWith(
            primaryColor: _config.primary,
            secondaryHeaderColor: _config.secondary),
//            textTheme: TextTheme(
//              title: TextStyle(
//                  fontSize: _config.textSize.toDouble(),
//                  color: Colors.black,
//                  backgroundColor: Colors.black,
//                  decorationColor: Color),
//            )),
//        child: DefaultTextStyle(
//            style: TextStyle(
//                color: _config.darkMode ? Colors.white : Colors.black),
        child: Scaffold(
            body: Center(child: myWidget),
            bottomNavigationBar: FancyBottomNavigation(
              tabs: [
                TabData(iconData: Icons.people, title: "Aktuality"),
//            TabData(iconData: Icons.mic, title: "Nahrávky"),
                TabData(iconData: Icons.audiotrack, title: "Zpěvník"),
                TabData(iconData: Icons.settings, title: "Nastavení"),
              ],
              onTabChangedListener: (int position) {
                setState(() {
                  _selectedIndex = position;
                });
              },
              barBackgroundColor: _config.primary,
              inactiveIconColor:
//                      _config.darkMode ? Colors.cyan[50] :
                  Colors.black,
              circleColor: _config.secondary,
              textColor:
//                  _config.darkMode ? Colors.white :
                  Colors.black,
            )));
  }
}
