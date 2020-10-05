import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Song> parseSongList(List<dynamic> data) {
    final List<Song> songs = <Song>[];
    for (var song in data) {
      if (song is QueryDocumentSnapshot) {
        song = song.data();
      }
      songs.add(Song(
          number: song['number'] as int,
          name: song['name'] as String,
          song: song['song'] as String));
    }
    return songs;
  }

  Future<void> loadChordSongs({bool force = false}) async {
    if (!force && _preferences.containsKey('songList')) {
      _chordSongs =
          parseSongList(jsonDecode(_preferences.getString('songList')));
    } else {
      final data = parseSongList((await FirebaseFirestore.instance
              .collection('songs')
              .orderBy('number')
              .get())
          .docs);
      _chordSongs = data;
      _preferences.setString('songList', jsonEncode(data));
    }
  }

  Future<void> loadNoChordSongs({bool force = false}) async {
    if (!force && _preferences.containsKey('noChordsList')) {
      _songs =
          parseSongList(jsonDecode(_preferences.getString('noChordsList')));
    } else {
      final data = parseSongList((await FirebaseFirestore.instance
              .collection('noChords')
              .orderBy('number')
              .get())
          .docs);
      _songs = data;
      _preferences.setString('noChordsList', jsonEncode(data));
    }
  }

  void refresh() {
    _controller.sink.add(_last);
    _historyConttroller.sink.add(_lastHistory);
  }

  void initFromPrefs(SharedPreferences prefs) {
    _preferences = prefs;
    loadChordSongs();
    loadNoChordSongs();
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
  }

  @override
  void dispose() {
    _historyConttroller.close();
    _controller.close();
  }
}
