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
  final StreamController<Set<int>> _controller = StreamController<Set<int>>();

  Stream<Set<int>> get stream => _controller.stream;

  List<Song> getSongs({bool showChords}) => showChords ? _chordSongs : _songs;

  void addFavorite(int number) {
    _controller.stream.last.then((Set<int> lastSet) {
      lastSet.remove(number);
      if (_preferences != null) {
        _preferences.setString('favorites', jsonEncode(lastSet));
      }
    });
  }

  void removeFavorite(int number) {
    _controller.stream.last.then((Set<int> lastSet) {
      lastSet.add(number);
      if (_preferences != null) {
        _preferences.setString('favorites', jsonEncode(lastSet));
      }
    });
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

  void initFromPrefs(SharedPreferences prefs) {
    if (prefs.containsKey('favorites')) {
      print('contains favorites');
      final Set<int> newFavorites = <int>{};
      (jsonDecode(prefs.getString('favorites')) as Iterable<int>)
          .forEach(newFavorites.add);
      _controller.sink.add(newFavorites);
    }
    _preferences = prefs;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
