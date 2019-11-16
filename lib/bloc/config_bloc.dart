import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/config.dart';
import 'bloc.dart';

class ConfigBloc implements Bloc {
  final StreamController<Config> _controller =
      StreamController<Config>.broadcast();
  SharedPreferences _preferences;

  Stream<Config> get stream => _controller.stream;

  void updateConfig(String key, dynamic value) {
    _controller.stream.last.then((Config newConfig) {
      switch (key) {
        case 'primary':
          if (value is Color) {
            newConfig.primary = createSwatch(value);
            if (_preferences != null) {
              _preferences.setInt('primary', value.value);
            }
          }
          break;
        case 'secondary':
          if (value is Color) {
            newConfig.secondary = value;
            if (_preferences != null) {
              _preferences.setInt('secondary', value.value);
            }
          }
          break;
        case 'songFontSize':
          if (value is int) {
            newConfig.songFontSize = value;
            if (_preferences != null) {
              _preferences.setInt('songFontSize', value);
            }
          }
          break;
        case 'showChords':
          if (value is bool) {
            newConfig.showChords = value;
            if (_preferences != null) {
              _preferences.setBool('showChords', value);
            }
          }
          break;
        case 'darkMode':
          if (value is bool) {
            newConfig.darkMode = value;
            if (_preferences != null) {
              _preferences.setBool('darkMode', value);
            }
          }
          break;
      }
      _controller.sink.add(newConfig);
    });
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
    if (prefs.containsKey('primary')) {
      final Color primary = Color(prefs.getInt('primary'));
      newConfig.primary = createSwatch(primary);
    }
    if (prefs.containsKey('secondary')) {
      newConfig.secondary = Color(prefs.getInt('secondary'));
    }
    if (prefs.containsKey('songFontSize')) {
      newConfig.songFontSize = prefs.getInt('songFontSize');
    }
    if (prefs.containsKey('showChords')) {
      newConfig.showChords = prefs.getBool('showChords');
    }
    if (prefs.containsKey('darkMode')) {
      newConfig.darkMode = prefs.getBool('darkMode');
    }
    _controller.sink.add(newConfig);
    _preferences = prefs;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
