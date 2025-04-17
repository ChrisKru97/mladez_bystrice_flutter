import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/gestures.dart' show ScaleUpdateDetails;
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/classes/config.dart';
import 'package:mladez_zpevnik/classes/history_entry.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/main.dart';
import 'package:diacritic/diacritic.dart';
import 'package:mladez_zpevnik/objectbox.g.dart';

const HISTORY_LIMIT = 50;

class SongsController extends GetxController {
  final songs = <Song>[].obs;
  final searchString = ''.obs;
  final songBox = objectbox.store.box<Song>();
  final historyBox = objectbox.store.box<HistoryEntry>();
  final Rx<Song> openSong = Song(
          number: 0,
          name: '',
          withChords: '',
          withoutChords: '',
          searchValue: '')
      .obs;

  Rx<Song> getSong(int number) {
    if (openSong.value.number != number) {
      final song = songBox.get(number);
      if (song != null) openSong.value = song;
    }
    return openSong;
  }

  List<Song> get filteredSongs =>
      searchString.value.isEmpty
          ? songs.value
          : songs.value
              .where(
                (element) => element.searchValue.contains(searchString.value),
              )
              .toList();

  void toggleFavorite(int? number) {
    if (number == null) {
      openSong.update((val) {
        if (val == null) return;
        val.isFavorite = !val.isFavorite;
        songBox.put(val);
      });
    }
    number ??= openSong.value.number;
    final songIndex = songs.indexWhere((element) => element.number == number);
    songs[songIndex].isFavorite = !songs[songIndex].isFavorite;
    songs.refresh();
    songBox.put(songs[songIndex]);
  }

  updateTranspose(int increment) =>
      () => openSong.update((val) {
        if (val == null) return;
        val.transpose += increment;
        songBox.put(val);
      });

  void updateFontScale(ScaleUpdateDetails scaleDetails) =>
      openSong.update((val) {
        if (val == null) return;
        val.fontSize = min(
          max(Get.width * 0.1, 20),
          max(
            min(Get.width * 0.02, 20),
            val.fontSize * pow(scaleDetails.scale, 1 / 16),
          ),
        );
      });

  void updateFontSize(double fontSize) => openSong.update((val) {
    if (val == null) return;
    val.fontSize = fontSize;
  });

  void saveFontSize(dynamic _) => songBox.put(openSong.value);

  List<Song> parseSongList(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
          Iterable<int>? favorites) =>
      data.map<Song>((e) {
        final song = e.data();
        final songState = songBox.get(song['number'] as int);
        return Song(
          number: song['number'] as int,
          name: song['name'] as String,
          withChords: song['withChords'] as String,
          withoutChords: song['withoutChords'] as String,
          searchValue: removeDiacritics(
              '${song['number']}.${song['name']}${song['withoutChords']}'
                  .toLowerCase()),
          isFavorite: favorites?.contains(song['number']) ??
              songState?.isFavorite ??
              false,
          fontSize: songState?.fontSize ?? 20,
        );
      }).toList();

  List<Song> parseNextSongList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
  ) =>
      data.map<Song>((e) {
        final song = e.data();
        final isFavorite = favoritesBox.read(song['number'].toString());
        final fontSize = fontSizesBox.read(song['number'].toString());
        return Song(
          number: song['number'] as int,
          name: song['name'] as String,
          // In the new collection, 'text' contains the song with chords in [brackets] format
          withChords: song['text'] as String,
          // For withoutChords, we'll use the same text but it will be displayed without chords
          withoutChords: song['text'] as String,
          searchValue: removeDiacritics(
            '${song['number']}.${song['name']}${song['text']}'.toLowerCase(),
          ),
          isFavorite: isFavorite ?? false,
          fontSize: fontSize ?? 20,
        );
      }).toList();

  Future<void> loadFromFirestore(Iterable<int>? favorites) async {
    final configController = Get.find<ConfigController>();
    final useNextCollection = configController.config.value.useNextCollection;

    final collectionName = useNextCollection ? 'songs_next' : 'songs';

    final query = FirebaseFirestore.instance
        .collection(collectionName);

    // The old collection has a 'checkRequired' field, the new one doesn't
    final queryWithFilters = useNextCollection
        ? query.orderBy('number')
        : query.where('checkRequired', isEqualTo: false).orderBy('number');

    final docs = await queryWithFilters.get();


    final parsedSongs = useNextCollection
        ? parseNextSongList(docs.docs)
        : parseSongList(docs.docs, favorites);

    songs.assignAll(parsedSongs);
    songBox.putMany(parsedSongs);
    Get.find<ConfigController>().config.update((val) {
      if (val == null) return;
      val.lastFirestoreFetch = DateTime.now();
    });
  }

  Future<void> loadSongs({bool force = false, Config? config}) async {
    Iterable<int>? favorites;
    final lastFirestoreFetch = config?.lastFirestoreFetch;
    final shouldRefresh = force ||
        songBox.isEmpty() ||
        (config != null &&
            (lastFirestoreFetch == null ||
                -lastFirestoreFetch.difference(DateTime.now()).inDays > 7));
    if (shouldRefresh) {
      await loadFromFirestore(favorites);
    } else {
      songs.assignAll(songBox.getAll());
    }
  }

  List<Map<String, dynamic>> historyList() => historyBox
      .query()
      .order(HistoryEntry_.openedAt, flags: Order.descending)
      .build()
      .find()
      .map((entry) =>
          {'songNumber': entry.songNumber, 'openedAt': entry.openedAt})
      .toList();

  void addToHistory(int number) {
    if (historyBox.count() > HISTORY_LIMIT) {
      final lastElement =
          historyBox.query().order(HistoryEntry_.openedAt).build().find().first;
      historyBox.remove(lastElement.id);
    }
    historyBox.put(HistoryEntry(songNumber: number, openedAt: DateTime.now()));
  }
}
