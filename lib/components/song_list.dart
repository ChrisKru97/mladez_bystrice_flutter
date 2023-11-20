import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import '../classes/song.dart';
import 'favorite_icon.dart';

class SongList extends StatelessWidget {
  const SongList({super.key, required this.songs, this.trimmed = false});

  final bool trimmed;
  final List<Song> songs;

  void _openSong(int number) {
    final SongsController songsController = Get.find();
    songsController.addToHistory(number);
    Get.toNamed('/song', arguments: number);
  }

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(
          child: Text('Zatím žádné písně', style: TextStyle(fontSize: 30)));
    }
    final Widget list = ListView.separated(
        separatorBuilder: (_, __) => const Divider(
              height: 2,
              // color: Colors.black12,
            ),
        itemCount: songs.length + (trimmed ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (trimmed && index == songs.length) {
            return ListTile(title: Container(height: 70));
          }
          final Song song = songs.elementAt(index);
          return ListTile(
            title: Text('${song.number}. ${song.name}'),
            onTap: () => _openSong(song.number),
            trailing: FavoriteIcon(song.isFavorite, song.number),
          );
        });
    if (!trimmed) {
      return list;
    }
    return RefreshIndicator.adaptive(
        onRefresh: () {
          final SongsController songsController = Get.find();
          return songsController.loadSongs(force: true);
        },
        child: list);
  }
}
