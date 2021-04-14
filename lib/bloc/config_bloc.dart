import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/config.dart';
import 'bloc.dart';

class ConfigBloc implements Bloc {
  final StreamController<Config> _controller =
      StreamController<Config>.broadcast();
  SharedPreferences _preferences;
  Config _last = Config();

  Stream<Config> get stream => _controller.stream;

  bool get showChords => _last.showChords;

  void refresh() {
    _controller.sink.add(_last);
  }

  void updateConfig(String key, dynamic value) {
    switch (key) {
      case 'primary':
        if (value is Color) {
          _last.primary = createSwatch(value);
          _preferences?.setInt('primary', value.value);
        }
        break;
      case 'secondary':
        if (value is Color) {
          _last.secondary = value;
          _preferences?.setInt('secondary', value.value);
        }
        break;
      case 'songFontSize':
        if (value is double) {
          _last.songFontSize = value;
          _preferences?.setDouble('songFontSize', value);
        }
        break;
      case 'showChords':
        if (value is bool) {
          _last.showChords = value;
          _preferences?.setBool('showChords', value);
        }
        break;
      case 'darkMode':
        if (value is bool) {
          _last.darkMode = value;
          _preferences?.setBool('darkMode', value);
        }
        break;
      case 'alignCenter':
        if (value is bool) {
          _last.alignCenter = value;
          _preferences?.setBool('alignCenter', value);
        }
        break;
    }
    _controller.sink.add(_last);
  }

  MaterialColor createSwatch(Color color) {
    final Map<int, Color> swatch = <int, Color>{
      50: color.withOpacity(.1),
      100: color.withOpacity(.2),
      200: color.withOpacity(.3),
      300: color.withOpacity(.4),
      400: color.withOpacity(.5),
      500: color.withOpacity(.6),
      600: color.withOpacity(.7),
      700: color.withOpacity(.8),
      800: color.withOpacity(.9),
      900: color.withOpacity(1),
    };
    return MaterialColor(color.value, swatch);
  }

  void initFromPrefs(SharedPreferences prefs, Config newConfig) {
    if (prefs.containsKey('config')) {
      final String configString = prefs.getString('config');
      final dynamic data = jsonDecode(configString);
      if (data['primary'] != null) {
        newConfig.primary = createSwatch(Color.fromRGBO(
            data['primary']['red'] as int,
            data['primary']['green'] as int,
            data['primary']['blue'] as int,
            1));
      }
      if (data['secondary'] != null) {
        newConfig.secondary = Color.fromRGBO(
            data['secondary']['red'] as int,
            data['secondary']['green'] as int,
            data['secondary']['blue'] as int,
            1);
      }
      if (data['songFontSize'] != null) {
        newConfig.songFontSize = (data['songFontSize'] as int).toDouble();
      }
      if (data['showChords'] != null) {
        newConfig.showChords = data['showChords'] as bool;
      }
      if (data['darkMode'] != null) {
        newConfig.darkMode = data['darkMode'] as bool;
      }
      prefs.remove('config');
    }
    if (prefs.containsKey('primary')) {
      final Color primary = Color(prefs.getInt('primary'));
      newConfig.primary = createSwatch(primary);
    }
    if (prefs.containsKey('secondary')) {
      newConfig.secondary = Color(prefs.getInt('secondary'));
    }
    if (prefs.containsKey('songFontSize')) {
      newConfig.songFontSize = prefs.getDouble('songFontSize');
    }
    if (prefs.containsKey('showChords')) {
      newConfig.showChords = prefs.getBool('showChords');
    }
    if (prefs.containsKey('darkMode')) {
      newConfig.darkMode = prefs.getBool('darkMode');
    }
    if (prefs.containsKey('alignCenter')) {
      newConfig.alignCenter = prefs.getBool('alignCenter');
    }
    _controller.sink.add(newConfig);
    _last = newConfig;
    _preferences = prefs;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
