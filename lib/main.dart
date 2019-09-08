import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/social.dart';
import 'package:mladez_zpevnik/songs.dart';
import 'package:mladez_zpevnik/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Mládež Bystřice',
            theme: theme,
            home: MyHomePage(),
          );
        });
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
              data['primary'] != null
                  ? Color.fromRGBO(data['primary']['red'],
                      data['primary']['green'], data['primary']['blue'], 1.0)
                  : Colors.blue,
              data['secondary'] != null
                  ? Color.fromRGBO(
                      data['secondary']['red'],
                      data['secondary']['green'],
                      data['secondary']['blue'],
                      1.0)
                  : Colors.green[800],
              data['darkMode'] ?? false,
              data['songFontSize'] ?? 28,
              data['textSize'] ?? 14,
              data['showChords'] ?? false);
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
    Map<int, Color> primary = {
      50: _config.primary.withOpacity(.1),
      100: _config.primary.withOpacity(.2),
      200: _config.primary.withOpacity(.3),
      300: _config.primary.withOpacity(.4),
      400: _config.primary.withOpacity(.5),
      500: _config.primary.withOpacity(.6),
      600: _config.primary.withOpacity(.7),
      700: _config.primary.withOpacity(.8),
      800: _config.primary.withOpacity(.9),
      900: _config.primary.withOpacity(1),
    };
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
          primarySwatch: MaterialColor(_config.primary.value, primary),
          brightness: brightness,
          secondaryHeaderColor: _config.secondary),
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        if (_preferences == null) {
          return Scaffold(
            body: SpinKitWave(color: theme.secondaryHeaderColor),
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
        return Scaffold(
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
              barBackgroundColor: theme.primaryColor,
              inactiveIconColor: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              circleColor: theme.secondaryHeaderColor,
              textColor: Colors.white,
            ));
      },
    );
  }
}
