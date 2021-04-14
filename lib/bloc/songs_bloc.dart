import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/song.dart';
import 'bloc.dart';

class SongsBloc implements Bloc {
  SharedPreferences _preferences;
  List<Song> _songs;
  final StreamController<Set<int>> _controller =
      StreamController<Set<int>>.broadcast();
  final StreamController<List<int>> _historyConttroller =
      StreamController<List<int>>.broadcast();
  Set<int> _last = <int>{};
  List<int> _lastHistory = <int>[];

  Stream<Set<int>> get stream => _controller.stream;

  Stream<List<int>> get historyStream => _historyConttroller.stream;

  List<Song> getSongs() => _songs;

  Song getSong(int number) => _songs?.elementAt(number);

  void addFavorite(int number) {
    _last.add(number);
    _controller.sink.add(_last);
    _preferences?.setStringList(
        'favorites', _last.map((int i) => i.toString()).toList());
  }

  void removeFavorite(int number) {
    _last.remove(number);
    _controller.sink.add(_last);
    _preferences?.setStringList(
        'favorites', _last.map((int i) => i.toString()).toList());
  }

  void addToHistory(int number) {
    if (_lastHistory.length > 50) {
      _lastHistory.removeLast();
    }
    if (_lastHistory.isEmpty || _lastHistory.elementAt(0) != number) {
      _lastHistory.insert(0, number);
      _historyConttroller.sink.add(_lastHistory);
      _preferences?.setStringList(
          'history', _lastHistory.map((int i) => i.toString()).toList());
    }
  }

  List<Song> parseSongList(List<dynamic> data) {
    final List<Song> songs = <Song>[];
    for (dynamic song in data) {
      if (song is QueryDocumentSnapshot) {
        song = song.data();
      }
      songs.add(Song(
          number: song['number'] as int,
          name: song['name'] as String,
          withChords: song['withChords'] as String,
          withoutChords: song['withoutChords'] as String));
    }
    return songs;
  }

  Future<void> loadSongs({bool force = false}) async {
    if (!force && _preferences != null && _preferences.containsKey('songs')) {
      final dynamic decodedList = jsonDecode(_preferences.getString('songs'));
      if (decodedList is List) {
        _songs = parseSongList(decodedList);
      }
    } else {
      final List<Song> data = parseSongList((await FirebaseFirestore.instance
              .collection('songs')
              .where('checkRequired', isEqualTo: false)
              .orderBy('number')
              .get())
          .docs);
      _songs = data;
      await _preferences?.setString('songs', jsonEncode(data));
    }
  }

  void refresh() {
    _controller.sink.add(_last);
    _historyConttroller.sink.add(_lastHistory);
  }

  void initFromPrefs(SharedPreferences prefs) {
    _preferences = prefs;
    loadSongs();
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
