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
  Config _config = Config(Colors.blue, Colors.green[800], 22, 14, false);

  _saveSettings(var newValue) {
    if (newValue is int) {
      Config config = Config(_config.primary, _config.secondary, newValue,
          _config.textSize, _config.showChords);
      _preferences.setString('config', jsonEncode(config));
      this.setState(() {
        _config = config;
      });
    } else if (newValue is Config) {
      _preferences.setString('config', jsonEncode(newValue));
      this.setState(() {
        _config = newValue;
      });
    }
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      String configString = value.getString('config') ?? '';
      if (configString != '') {
        var data = jsonDecode(configString);
        Config config = Config(
            data['primary'] != null
                ? Color.fromRGBO(data['primary']['red'],
                    data['primary']['green'], data['primary']['blue'], 1.0)
                : Colors.blue,
            data['secondary'] != null
                ? Color.fromRGBO(data['secondary']['red'],
                    data['secondary']['green'], data['secondary']['blue'], 1.0)
                : Colors.green[800],
            data['songFontSize'] ?? 22,
            data['textSize'] ?? 14,
            data['showChords'] ?? false);
        Map<int, Color> primary = {
          50: config.primary.withOpacity(.1),
          100: config.primary.withOpacity(.2),
          200: config.primary.withOpacity(.3),
          300: config.primary.withOpacity(.4),
          400: config.primary.withOpacity(.5),
          500: config.primary.withOpacity(.6),
          600: config.primary.withOpacity(.7),
          700: config.primary.withOpacity(.8),
          800: config.primary.withOpacity(.9),
          900: config.primary.withOpacity(1),
        };
        Brightness brightness = DynamicTheme.of(context).data.brightness;
        DynamicTheme.of(context).setThemeData(ThemeData(
            primarySwatch: MaterialColor(config.primary.value, primary),
            textTheme: TextTheme(
                display3: TextStyle(
                    fontSize: config.textSize.toDouble() + 6,
                    fontWeight: FontWeight.bold),
                display4: TextStyle(fontSize: config.textSize.toDouble())),
            secondaryHeaderColor: config.secondary));
        if (brightness == Brightness.dark) {
          DynamicTheme.of(context).setBrightness(Brightness.dark);
        }
        setState(() {
          _config = config;
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
    Color primary = DynamicTheme.of(context).data.primaryColor;
    Color secondary = DynamicTheme.of(context).data.secondaryHeaderColor;
    Brightness brightness = DynamicTheme.of(context).data.brightness;
    if (_preferences == null) {
      return Scaffold(
        body: SpinKitWave(color: secondary),
      );
    }
    Widget myWidget;
    switch (_selectedIndex) {
      case 0:
        myWidget = Social(
          preferences: _preferences,
        );
        break;
//      case 1:
//        myWidget = Recordings(preferences: _preferences, config: _config);
//        break;
      case 1:
        myWidget = SongBook(
          preferences: _preferences,
          showChords: _config.showChords,
          saveSettings: _saveSettings,
        );
        break;
      case 2:
        myWidget = Settings(config: _config, saveSettings: _saveSettings);
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
          barBackgroundColor: primary,
          inactiveIconColor:
              brightness == Brightness.light ? Colors.black45 : Colors.white,
          circleColor: secondary,
          textColor: Colors.white,
        ));
  }
}
