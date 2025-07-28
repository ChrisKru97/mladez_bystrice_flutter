import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/playlist.dart';
import 'package:mladez_zpevnik/main.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

class PlaylistController extends GetxController {
  final playlistBox = objectbox.store.box<Playlist>();
  final playlists = <Playlist>[].obs;
  final openPlaylist = Playlist(name: '').obs;
  
  AnalyticsService get _analytics => Get.find<AnalyticsService>();
  SongsController get _songsController => Get.find<SongsController>();

  void removeFromPlaylist(int index) => openPlaylist.update((val) {
        if (val == null) {
          return;
        }
        try {
          final songNumber = val.songsOrder![index];
          final song = _songsController.songs.firstWhere((s) => s.number == songNumber);
          val.songsOrder!.removeAt(index);
          syncWithObs(val);
          _analytics.logRemoveFromPlaylist(
            song.number.toString(),
            song.name,
            val.id.toString(),
            val.name,
          );
        } catch (error, stackTrace) {
          _analytics.recordError(error, stackTrace, reason: 'Failed to remove from playlist');
        }
      });

  void syncWithObs(Playlist val) {
    playlistBox.put(val);
    final playlistIndex =
        playlists.indexWhere((element) => element.id == val.id);
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
        try {
          val.songsOrder ??= [];
          val.songsOrder!.add(songNumber);
          syncWithObs(val);
          final song = _songsController.songs.firstWhere((s) => s.number == songNumber);
          _analytics.logAddToPlaylist(
            song.number.toString(),
            song.name,
            val.id.toString(),
            val.name,
          );
        } catch (error, stackTrace) {
          _analytics.recordError(error, stackTrace, reason: 'Failed to add to playlist');
        }
      });

  Rx<Playlist> getPlaylist(int id) {
    if (openPlaylist.value.id != id) {
      final playlist = playlistBox.get(id);
      if (playlist != null) openPlaylist.value = playlist;
    }
    return openPlaylist;
  }

  void init() {
    try {
      playlists.value = playlistBox.getAll();
      _updateUserProperties();
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to initialize playlists');
    }
  }

  void _updateUserProperties() {
    _analytics.setUserProperties(playlistCount: playlists.length);
  }

  void addPlaylist(String name) {
    try {
      final playlist = Playlist(name: name);
      playlistBox.put(playlist);
      playlists.add(playlist);
      _analytics.logPlaylistCreated(playlist.id.toString(), name);
      _updateUserProperties();
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to create playlist');
    }
  }

  void removePlaylist(int id) {
    try {
      final playlistIndex = playlists.indexWhere((element) => element.id == id);
      if (playlistIndex >= 0) {
        final playlist = playlists[playlistIndex];
        playlistBox.remove(id);
        playlists.removeAt(playlistIndex);
        _analytics.logPlaylistDeleted(id.toString(), playlist.name);
        _updateUserProperties();
      }
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'Failed to remove playlist');
    }
  }
}
