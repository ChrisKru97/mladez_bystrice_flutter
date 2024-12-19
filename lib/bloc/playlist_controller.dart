import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mladez_zpevnik/classes/playlist.dart';

class PlaylistController extends GetxController {
  final playlistBox = GetStorage('playlists');
  final playlists = <Playlist>[].obs;
  final openPlaylist = Playlist(name: '').obs;

  void removeFromPlaylist(int index) => openPlaylist.update((val) {
        if (val == null) {
          return;
        }
        val.songsOrder!.removeAt(index);
        syncWithObs(val);
      });

  void syncWithObs(Playlist val) {
    // TODO can read also lists and maps
    playlistBox.write(val.name, jsonEncode(val));
    final playlistIndex =
        playlists.indexWhere((element) => element.name == val.name);
    playlists[playlistIndex] = val;
    playlists.refresh();
  }

  void handleReorder(int oldIndex, int newIndex) => openPlaylist.update((val) {
        if (val == null) return;
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        val.songsOrder?.insert(newIndex, val.songsOrder!.removeAt(oldIndex));
        syncWithObs(val);
      });

  void addToPlaylist(int songNumber) => openPlaylist.update((val) {
        if (val == null) return;
        val.songsOrder ??= [];
        val.songsOrder!.add(songNumber);
        syncWithObs(val);
      });

  Rx<Playlist> getPlaylist(String name) {
    if (openPlaylist.value.name != name) {
      final asString = playlistBox.read(name);
      if (asString != null) {
        final playlist = Playlist.fromJson(jsonDecode(playlistBox.read(name)));
        openPlaylist.value = playlist;
      }
    }
    return openPlaylist;
  }

  @override
  void onInit() {
    ever(
        playlists,
        (playlists) => GetStorage()
            .write('playlists', playlists.map((p) => p.name).toList()));
    super.onInit();
  }

  void init() async {
    await playlistBox.initStorage;
    final existingPlaylists =
        List<String>.from(GetStorage().read('playlists') ?? <String>[]);
    playlists.value = existingPlaylists.map((e) {
      final asString = playlistBox.read(e);
      if (asString == null) {
        return Playlist(name: e);
      }
      return Playlist.fromJson(jsonDecode(asString));
    }).toList();
  }

  void addPlaylist(String name) {
    final playlist = Playlist(name: name);
    playlistBox.write(name, jsonEncode(playlist));
    playlists.add(playlist);
  }

  void removePlaylist(String name) {
    playlistBox.remove(name);
    final playlistIndex =
        playlists.indexWhere((element) => element.name == name);
    playlists.removeAt(playlistIndex);
  }
}
