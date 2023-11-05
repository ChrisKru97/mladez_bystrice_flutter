import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import '../classes/song.dart';

class SongsController extends GetxController {
  var history = <int>[].obs;
  var favorites = (<int>{}).obs;
  var songs = <Song>[].obs;

  void toggleFavorite(int number) {
    if (favorites.contains(number)) {
      favorites.remove(number);
    } else {
      favorites.add(number);
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

  Future<void> loadSongs() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signInAnonymously();
    songs.value = parseSongList((await FirebaseFirestore.instance
            .collection('songs')
            .where('checkRequired', isEqualTo: false)
            .orderBy('number')
            .get())
        .docs);
  }

  void addToHistory(int number) {
    history.add(number);
  }
}
