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
import 'package:shared_preferences/shared_preferences.dart';

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

  List<Song> get filteredSongs => searchString.value.isEmpty
      ? songs.value
      : songs.value
          .where((element) => element.searchValue.contains(searchString.value))
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

  void updateFontScale(ScaleUpdateDetails scaleDetails) =>
      openSong.update((val) {
        if (val == null) return;
        val.fontSize = min(
            max(Get.width * 0.1, 20),
            max(min(Get.width * 0.02, 20),
                val.fontSize * pow(scaleDetails.scale, 1 / 16)));
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

  Future<void> loadFromFirestore(Iterable<int>? favorites) async {
    final docs = await FirebaseFirestore.instance
        .collection('songs')
        .where('checkRequired', isEqualTo: false)
        .orderBy('number')
        .get();
    final parsedSongs = parseSongList(docs.docs, favorites);
    songs.assignAll(parsedSongs);
    songBox.putMany(parsedSongs);
    Get.find<ConfigController>().config.update((val) {
      if (val == null) return;
      val.lastFirestoreFetch = DateTime.now();
    });
  }

  Future<Iterable<int>?> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history')?.map(int.parse);
    final favorites = prefs.getStringList('favorites')?.map(int.parse);
    if (history != null) {
      historyBox.putMany(history
          .map((e) => HistoryEntry(songNumber: e, openedAt: DateTime.now()))
          .toList());
    }
    final configController = Get.find<ConfigController>();
    configController.config.update((val) {
      if (val == null) return;
      val.migrated = true;
    });
    return favorites;
  }

  Future<void> loadSongs({bool force = false, Config? config}) async {
    Iterable<int>? favorites;
    if (config != null && !config.migrated) {
      favorites = await migrate();
    }
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
