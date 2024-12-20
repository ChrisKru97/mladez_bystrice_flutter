import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/gestures.dart' show ScaleUpdateDetails;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/classes/config.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:diacritic/diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

const HISTORY_LIMIT = 50;

class SongsController extends GetxController {
  final songs = <Song>[].obs;
  final searchString = ''.obs;
  final favoritesBox = GetStorage('favorites');
  final fontSizesBox = GetStorage('fontSizes');
  final Rx<Song> openSong = Song(
          number: 0,
          name: '',
          withChords: '',
          withoutChords: '',
          searchValue: '')
      .obs;

  Rx<Song> getSong(int number) {
    if (openSong.value.number != number) {
      final song = songs.firstWhereOrNull((song) => song.number == number);
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
      });
    }
    number ??= openSong.value.number;
    final songIndex = songs.indexWhere((element) => element.number == number);
    songs[songIndex].isFavorite = !songs[songIndex].isFavorite;
    favoritesBox.write(number.toString(), songs[songIndex].isFavorite);
    songs.refresh();
  }

  updateTranspose(int increment) => () => openSong.update((val) {
        if (val == null) return;
        val.transpose += increment;
      });

  void updateFontScale(ScaleUpdateDetails scaleDetails) =>
      openSong.update((val) {
        if (val == null) return;
        val.fontSize = min(
            max(Get.width * 0.1, 20),
            max(min(Get.width * 0.02, 20),
                val.fontSize * pow(scaleDetails.scale, 1 / 16)));
      });

  void saveFontSize(_) => fontSizesBox.write(
      openSong.value.number.toString(), openSong.value.fontSize);

  void updateFontSize(double fontSize) => openSong.update((val) {
        if (val == null) return;
        val.fontSize = fontSize;
      });

  List<Song> parseSongList(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data) =>
      data.map<Song>((e) {
        final song = e.data();
        final isFavorite = favoritesBox.read(song['number'].toString());
        final fontSize = fontSizesBox.read(song['number'].toString());
        return Song(
          number: song['number'] as int,
          name: song['name'] as String,
          withChords: song['withChords'] as String,
          withoutChords: song['withoutChords'] as String,
          searchValue: removeDiacritics(
              '${song['number']}.${song['name']}${song['withoutChords']}'
                  .toLowerCase()),
          isFavorite: isFavorite ?? false,
          fontSize: fontSize ?? 20,
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
  }

  Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history');
    GetStorage().write('history', jsonEncode(history?.map(int.parse).toList()));
    final favorites = prefs.getStringList('favorites')?.map(int.parse);
    favorites?.forEach((favorite) {
      favoritesBox.write(favorite.toString(), true);
    });
    prefs.clear();
    final configController = Get.find<ConfigController>();
    configController.config.update((val) {
      if (val == null) return;
      val.migrated = true;
    });
  }

  Future<void> loadSongs({bool force = false, Config? config}) async {
    if (config != null && !config.migrated) {
      await migrate();
    }
    final shouldRefresh = force || songs.isEmpty;
    if (shouldRefresh) {
      await loadFromFirestore();
    }
  }

  List<int>? historyList() =>
      jsonDecode(GetStorage().read('history') ?? "[]")?.cast<int>();

  void addToHistory(int number) {
    final historyList = this.historyList();
    if (historyList == null) {
      GetStorage().write('history', jsonEncode([number]));
      return;
    }
    historyList.insert(0, number);
    GetStorage().write(
        'history',
        jsonEncode(historyList.length > 50
            ? historyList.sublist(0, HISTORY_LIMIT)
            : historyList));
  }
}
