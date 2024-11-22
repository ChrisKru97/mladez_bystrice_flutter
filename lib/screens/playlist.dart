import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/components/playlist_fab.dart';
import 'package:mladez_zpevnik/dialogs/number_select.dart';
import 'package:mladez_zpevnik/dialogs/song_picker.dart';

class PlaylistDisplay extends StatelessWidget {
  const PlaylistDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as int;
    final PlaylistController playlistController = Get.find();
    final SongsController songsController = Get.find();
    final playlist = playlistController.getPlaylist(id);
    return Scaffold(
        appBar: AppBar(
          title: Text(playlist.value.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.playlist_add),
              onPressed: () => Get.bottomSheet(SongPicker()),
            ),
            IconButton(
                icon: const Icon(Icons.plus_one),
                onPressed: () => Get.bottomSheet(
                    NumberSelect(onSelect: playlistController.addToPlaylist))),
          ],
        ),
        floatingActionButton: Obx(() =>
            playlist.value.songsOrder?.isNotEmpty == true
                ? PlaylistFab(playlist: playlist.value)
                : const Center()),
        body: Obx(() {
          final randomOffset = Random().nextInt(1000);
          return playlist.value.songsOrder?.isNotEmpty == true
              ? ReorderableListView(
                  onReorder: playlistController.handleReorder,
                  children: List.generate(playlist.value.songsOrder!.length,
                      (int index) {
                    final songNumber = playlist.value.songsOrder![index];
                    final song = songsController.songBox.get(songNumber);
                    final key = '$songNumber${index + randomOffset}';
                    if (song == null) return const Center();
                    return DismissibleRemove(
                        key: Key(key),
                        dismissibleKey: key,
                        onRemove: () =>
                            playlistController.removeFromPlaylist(index),
                        child: ListTile(
                            title: Text('${song.number}. ${song.name}',
                                overflow: TextOverflow.ellipsis),
                            onTap: () =>
                                Get.toNamed('/song', arguments: song.number),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            )));
                  }))
              : Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () => Get.bottomSheet(SongPicker()),
                        child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.playlist_add, size: 50),
                              Text('Vybrat'),
                            ])),
                    GestureDetector(
                        onTap: () => Get.bottomSheet(NumberSelect(
                            onSelect: playlistController.addToPlaylist)),
                        child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.plus_one, size: 50),
                              Text('Zadat číslo'),
                            ])),
                  ],
                ));
        }));
  }
}
