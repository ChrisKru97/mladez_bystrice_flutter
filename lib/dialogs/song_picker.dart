import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/dialogs/bottom_dialog_container.dart';

class SongPicker extends StatelessWidget {
  const SongPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final PlaylistController playlistController = Get.find();
    int selectedItemIndex = 0;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: BottomDialogContainer(
        child: Stack(
          children: [
            CupertinoPicker(
              diameterRatio: 2,
              squeeze: 1,
              itemExtent: 26,
              onSelectedItemChanged: (int value) {
                selectedItemIndex = value;
              },
              children:
                  songsController.songs
                      .map(
                        (song) => Text(
                          '${song.number}. ${song.name}',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                      .toList(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white70),
                ),
                onPressed: () {
                  final songNumber =
                      songsController.songs[selectedItemIndex].number;
                  playlistController.addToPlaylist(songNumber);
                  Get.back();
                },
                child: const Text('Přidat'),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white70),
                ),
                onPressed: Get.back,
                child: const Text('Zrušit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
