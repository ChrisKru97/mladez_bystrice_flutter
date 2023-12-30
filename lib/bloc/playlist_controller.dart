import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/playlist.dart';
import 'package:mladez_zpevnik/main.dart';

class PlaylistController extends GetxController {
  final playlistBox = objectbox.store.box<Playlist>();
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
        val.songsOrder ??= [];
        val.songsOrder!.add(songNumber);
        syncWithObs(val);
      });

  Rx<Playlist> getPlaylist(int id) {
    if (openPlaylist.value.id != id) {
      final playlist = playlistBox.get(id);
      if (playlist != null) openPlaylist.value = playlist;
    }
    return openPlaylist;
  }

  void init() {
    playlists.value = playlistBox.getAll();
  }

  void addPlaylist(String name) {
    final playlist = Playlist(name: name);
    playlistBox.put(playlist);
    playlists.add(playlist);
  }

  void removePlaylist(int id) {
    playlistBox.remove(id);
    final playlistIndex = playlists.indexWhere((element) => element.id == id);
    playlists.removeAt(playlistIndex);
  }
}
