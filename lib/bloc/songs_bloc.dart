import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/song.dart';
import 'bloc.dart';

class SongsBloc implements Bloc {
  SharedPreferences _preferences;
  List<Song> _songs;
  List<Song> _chordSongs;
  final StreamController<Set<int>> _controller =
      StreamController<Set<int>>.broadcast();
  final StreamController<List<int>> _historyConttroller =
      StreamController<List<int>>.broadcast();
  Set<int> _last = <int>{};
  List<int> _lastHistory = <int>[];

  Stream<Set<int>> get stream => _controller.stream;

  Stream<List<int>> get historyStream => _historyConttroller.stream;

  List<Song> getSongs({bool showChords}) =>
      showChords != null && showChords ? _chordSongs : _songs;

  Song getSong(int number, {bool showChords}) =>
      (showChords ?? false ? _chordSongs : _songs).elementAt(number);

  void addFavorite(int number) {
    _last.add(number);
    _controller.sink.add(_last);
    if (_preferences != null) {
      _preferences.setStringList(
          'favorites', _last.map((int i) => i.toString()).toList());
    }
  }

  void removeFavorite(int number) {
    _last.remove(number);
    _controller.sink.add(_last);
    if (_preferences != null) {
      _preferences.setStringList(
          'favorites', _last.map((int i) => i.toString()).toList());
    }
  }

  void addToHistory(int number) {
    if (_lastHistory.length > 50) {
      _lastHistory.removeLast();
    }
    if (_lastHistory.length == 0 || _lastHistory.elementAt(0) != number) {
      _lastHistory.insert(0, number);
      _historyConttroller.sink.add(_lastHistory);
      if (_preferences != null) {
        _preferences.setStringList(
            'history', _lastHistory.map((int i) => i.toString()).toList());
      }
    }
  }

  void loadSongs() {
    List<Song> parseSongList(List<dynamic> data) {
      final List<Song> songs = <Song>[];
      for (final dynamic s in data) {
        songs.add(Song(
            number: s['number'] as int,
            name: s['name'] as String,
            song: s['song'] as String));
      }
      return songs;
    }

    rootBundle
        .loadStructuredData(
            'assets/zpevnik.json', (String s) async => await jsonDecode(s))
        .then((dynamic data) {
      if (data is List<dynamic>) {
        _chordSongs = parseSongList(data);
      }
    });
    rootBundle
        .loadStructuredData(
            'assets/noChords.json', (String s) async => await jsonDecode(s))
        .then((dynamic data) {
      if (data is List<dynamic>) {
        _songs = parseSongList(data);
      }
    });
  }

  void refresh() {
    _controller.sink.add(_last);
    _historyConttroller.sink.add(_lastHistory);
  }

  void initFromPrefs(SharedPreferences prefs) {
    if (prefs.containsKey('favorites')) {
      final Set<int> newFavorites = <int>{};
      prefs.getStringList('favorites').map(int.parse).forEach(newFavorites.add);
      _controller.sink.add(newFavorites);
      _last = newFavorites;
    }
    if (prefs.containsKey('history')) {
      _lastHistory = prefs.getStringList('history').map(int.parse).toList();
      _historyConttroller.sink.add(_lastHistory);
    }
    _preferences = prefs;
  }

  @override
  void dispose() {
    _historyConttroller.close();
    _controller.close();
  }
}
