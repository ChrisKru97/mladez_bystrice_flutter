import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/history_entry.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/main.dart';
import 'package:diacritic/diacritic.dart';
import 'package:mladez_zpevnik/objectbox.g.dart';

class SongsController extends GetxController {
  final history = <int>[].obs;
  final songs = <Song>[].obs;
  final searchString = ''.obs;
  final songBox = objectbox.store.box<Song>();
  final historyBox = objectbox.store.box<HistoryEntry>();

  List<Song> get filteredSongs => searchString.value.isEmpty
      ? songs.value
      : songs.value
          .where((element) => element.searchValue.contains(searchString.value))
          .toList();

  List<Song> get historySongs => history.value
      .map((songNumber) => songBox.get(songNumber))
      .whereType<Song>()
      .toList();

  void toggleFavorite(int number) {
    final songIndex = songs.indexWhere((element) => element.number == number);
    songs[songIndex].isFavorite = !songs[songIndex].isFavorite;
    songs.refresh();
    songBox.put(songs[songIndex]);
  }

  List<Song> parseSongList(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data) =>
      data.map<Song>((e) {
        final song = e.data();
        return Song(
          number: song['number'] as int,
          name: song['name'] as String,
          withChords: song['withChords'] as String,
          withoutChords: song['withoutChords'] as String,
          searchValue: removeDiacritics(
              '${song['number']}.${song['name']}${song['withoutChords']}'
                  .toLowerCase()),
        );
      }).toList();

  Future<void> loadFromFirestore() async {
    final docs = await FirebaseFirestore.instance
        .collection('songs')
        .where('checkRequired', isEqualTo: false)
        .orderBy('number')
        .get();
    final parsedSongs = parseSongList(docs.docs);
    songs.assignAll(parsedSongs);
    songBox.putMany(parsedSongs);
  }

  Future<void> loadSongs({bool force = false}) async {
    if (force || songBox.isEmpty()) {
      await loadFromFirestore();
    } else {
      songs.assignAll(songBox.getAll());
    }
  }

  void loadHistory() {
    final parsedHistory = historyBox
        .query()
        .order(HistoryEntry_.openedAt, flags: Order.descending)
        .build()
        .find()
        .map((e) => e.songNumber)
        .toList();
    history.assignAll(parsedHistory);
  }

  void init() {
    loadSongs();
    loadHistory();
  }

  void addToHistory(int number) {
    history.insert(0, number);
    if (history.length > 10) {
      history.removeLast();
      final lastElement =
          historyBox.query().order(HistoryEntry_.openedAt).build().find().first;
      historyBox.remove(lastElement.id);
    }
    historyBox.put(HistoryEntry(songNumber: number, openedAt: DateTime.now()));
  }
}
