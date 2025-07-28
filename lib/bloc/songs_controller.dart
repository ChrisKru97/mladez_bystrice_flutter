import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/gestures.dart' show ScaleUpdateDetails;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/classes/config.dart';
import 'package:mladez_zpevnik/classes/history_entry.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/main.dart';
import 'package:diacritic/diacritic.dart';
import 'package:mladez_zpevnik/objectbox.g.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';

const historyLimit = 50;

class SongsController extends GetxController {
  final songs = <Song>[].obs;
  final searchString = ''.obs;
  final songBox = objectbox.store.box<Song>();
  final historyBox = objectbox.store.box<HistoryEntry>();
  final Rx<Song> openSong =
      Song(number: 0, name: '', text: '', searchValue: '').obs;
  
  AnalyticsService get _analytics => Get.find<AnalyticsService>();

  Rx<Song> getSong(int number) {
    if (openSong.value.number != number) {
      final song = songBox.get(number);
      if (song != null) {
        openSong.value = song;
        _analytics.logSongView(song.number.toString(), song.name);
        addToHistory(number);
      }
    }
    return openSong;
  }

  List<Song> get filteredSongs =>
      searchString.value.isEmpty
          ? songs
          : songs
              .where(
                (element) => element.searchValue.contains(searchString.value),
              )
              .toList();

  void toggleFavorite(int? number) {
    try {
      if (number == null) {
        openSong.update((val) {
          if (val == null) return;
          val.isFavorite = !val.isFavorite;
          songBox.put(val);
          if (val.isFavorite) {
            _analytics.logAddToFavorites(val.number.toString(), val.name);
          } else {
            _analytics.logRemoveFromFavorites(val.number.toString(), val.name);
          }
        });
      }
      number ??= openSong.value.number;
      final songIndex = songs.indexWhere((element) => element.number == number);
      if (songIndex >= 0) {
        songs[songIndex].isFavorite = !songs[songIndex].isFavorite;
        songs.refresh();
        songBox.put(songs[songIndex]);
        
        if (songs[songIndex].isFavorite) {
          _analytics.logAddToFavorites(songs[songIndex].number.toString(), songs[songIndex].name);
        } else {
          _analytics.logRemoveFromFavorites(songs[songIndex].number.toString(), songs[songIndex].name);
        }
        
        _updateUserProperties();
      }
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to toggle favorite');
    }
  }

  updateTranspose(int increment) =>
      () => openSong.update((val) {
        if (val == null) return;
        val.transpose += increment;
        songBox.put(val);
        _analytics.logChordTransposition(val.number.toString(), val.transpose);
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

  void saveFontSize(dynamic _) {
    songBox.put(openSong.value);
    _analytics.logFontSizeChange(openSong.value.number.toString(), openSong.value.fontSize);
  }

  List<Song> parseSongList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
    Iterable<int>? favorites,
  ) =>
      data.map<Song>((e) {
        final song = e.data();
        final songState = songBox.get(song['number'] as int);
        final isFavorite =
            favorites?.contains(song['number']) ??
            songState?.isFavorite ??
            false;
        final fontSize = songState?.fontSize ?? 20;
        return Song(
          number: song['number'] as int,
          name: song['name'] as String,
          text: song['text'] as String,
          searchValue: removeDiacritics(
            '${song['number']}.${song['name']}${song['text']}'.toLowerCase(),
          ),
          isFavorite: isFavorite,
          fontSize: fontSize,
        );
      }).toList();

  Future<void> loadFromFirestore(Iterable<int>? favorites) async {
    try {
      final docs =
          await FirebaseFirestore.instance
              .collection('songs_next')
              .orderBy('number')
              .get();

      final parsedSongs = parseSongList(docs.docs, favorites);

      songs.assignAll(parsedSongs);
      songBox.putMany(parsedSongs);
      Get.find<ConfigController>().config.update((val) {
        if (val == null) return;
        val.lastFirestoreFetch = DateTime.now();
      });
      
      _analytics.logDataSync(parsedSongs.length);
      _analytics.setCrashlyticsKeys(songCount: parsedSongs.length);
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to load songs from Firestore');
      rethrow;
    }
  }

  Future<void> loadSongs({bool force = false, Config? config}) async {
    try {
      Iterable<int>? favorites;
      final lastFirestoreFetch = config?.lastFirestoreFetch;
      final shouldRefresh =
          force ||
          songBox.isEmpty() ||
          (config != null &&
              (lastFirestoreFetch == null ||
                  -lastFirestoreFetch.difference(DateTime.now()).inDays > 7));
      if (shouldRefresh) {
        await loadFromFirestore(favorites);
      } else {
        final localSongs = songBox.getAll();
        songs.assignAll(localSongs);
        _analytics.logDataLoadLocal(localSongs.length);
      }
      
      // Remove splash screen after songs are loaded
      FlutterNativeSplash.remove();
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to load songs');
      // Still remove splash screen even if loading fails
      FlutterNativeSplash.remove();
      rethrow;
    }
  }

  List<Map<String, dynamic>> historyList() =>
      historyBox
          .query()
          .order(HistoryEntry_.openedAt, flags: Order.descending)
          .build()
          .find()
          .map(
            (entry) => {
              'songNumber': entry.songNumber,
              'openedAt': entry.openedAt,
            },
          )
          .toList();

  void addToHistory(int number) {
    try {
      if (historyBox.count() > historyLimit) {
        final lastElement =
            historyBox.query().order(HistoryEntry_.openedAt).build().find().first;
        historyBox.remove(lastElement.id);
      }
      historyBox.put(HistoryEntry(songNumber: number, openedAt: DateTime.now()));
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to add to history');
    }
  }

  void updateSearchString(String search) {
    searchString.value = removeDiacritics(search.toLowerCase());
    if (search.isNotEmpty) {
      _analytics.logSearch(search);
    }
  }

  void _updateUserProperties() {
    final favoriteCount = songs.where((song) => song.isFavorite).length;
    _analytics.setUserProperties(favoriteCount: favoriteCount);
  }
}
