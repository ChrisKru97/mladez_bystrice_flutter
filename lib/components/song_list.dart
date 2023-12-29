import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/classes/song_with_history.dart';
import 'favorite_icon.dart';

class SongList extends StatelessWidget {
  const SongList(
      {super.key, this.songs, this.historyList, this.trimmed = false});

  final bool trimmed;
  final List<Song>? songs;
  final List<SongWithHistory>? historyList;

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final songsList = songs ?? historyList;
    if (songsList == null || songsList.isEmpty) {
      return Center(
          child: Text('Žádné písně',
              style: TextStyle(
                  fontSize: 30,
                  color: Get.isDarkMode ? Colors.white : Colors.black)));
    }
    final Widget list = Scrollbar(
        thumbVisibility: trimmed,
        thickness: 10,
        radius: const Radius.circular(5),
        child: ListView.separated(
            separatorBuilder: (_, __) => const Divider(
                  height: 2,
                ),
            padding: trimmed
                ? EdgeInsets.only(
                    bottom: max(20, MediaQuery.of(context).padding.bottom) + 60)
                : null,
            itemCount: songsList.length,
            itemBuilder: (BuildContext context, int index) {
              final dynamic element = songsList.elementAt(index);
              final Song song =
                  element is SongWithHistory ? element.song : element;
              final openedAt =
                  element is SongWithHistory ? element.openedAt : null;
              return ListTile(
                onLongPress: () => songsController.toggleFavorite(song.number),
                title: Text('${song.number}. ${song.name}',
                    overflow: TextOverflow.ellipsis),
                onTap: () {
                  songsController.addToHistory(song.number);
                  Get.toNamed('/song', arguments: song.number);
                },
                trailing: openedAt == null
                    ? FavoriteIcon(song.isFavorite, number: song.number)
                    : Text(
                        '${openedAt.hour.toString().padLeft(2, '0')}:${openedAt.minute.toString().padLeft(2, '0')} ${openedAt.day}.${openedAt.month}.${openedAt.year - 2000}'),
                contentPadding: const EdgeInsets.only(left: 16, right: 12),
              );
            }));
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
