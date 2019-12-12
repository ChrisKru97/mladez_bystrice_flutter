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
  Set<int> _last = <int>{};

  Stream<Set<int>> get stream => _controller.stream;

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
  }

  void initFromPrefs(SharedPreferences prefs) {
    if (prefs.containsKey('favorites')) {
      final Set<int> newFavorites = <int>{};
      prefs.getStringList('favorites').map(int.parse).forEach(newFavorites.add);
      _controller.sink.add(newFavorites);
      _last = newFavorites;
    }
    _preferences = prefs;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
