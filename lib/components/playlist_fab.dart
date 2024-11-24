import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/playlist.dart';

class PlaylistFab extends StatelessWidget {
  const PlaylistFab({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
            heroTag: null,
            onPressed: () =>
                Get.toNamed('/present-song', arguments: playlist.songsOrder),
            mini: true,
            child: const Icon(Icons.present_to_all)),
        FloatingActionButton(
            onPressed: () =>
                Get.toNamed('/present-playlist', arguments: playlist.name),
            mini: true,
            child: const Icon(Icons.play_arrow)),
      ],
    );
  }
}
