import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'components/favorite_icon.dart';
import 'dialogs/font_settings.dart';

class SongDisplay extends StatelessWidget {
  const SongDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final number = Get.arguments as int;
    SongsController songsController = Get.find();
    final song = songsController.songBox.get(number);
    if (song == null) {
      Get.back();
      return const Center();
    }
    final ConfigController configController = Get.find();
    final String title = '${song.number}. ${song.name}';
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          FavoriteIcon(song.isFavorite, song.number, white: true)
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) =>
            configController.config.update((val) {
          if (val == null) return;
          val.songFontSize = min(
              40, max(12, val.songFontSize * pow(scaleDetails.scale, 1 / 16)));
        }),
        child: Obx(() => SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: configController.config.value.alignCenter
                  ? Center(
                      child: Text(
                      configController.config.value.showChords
                          ? song.withChords
                          : song.withoutChords,
                      textAlign: configController.config.value.alignCenter
                          ? TextAlign.center
                          : TextAlign.left,
                      style: TextStyle(
                          fontSize: configController.config.value.songFontSize),
                    ))
                  : Text(
                      configController.config.value.showChords
                          ? song.withChords
                          : song.withoutChords,
                      textAlign: configController.config.value.alignCenter
                          ? TextAlign.center
                          : TextAlign.left,
                      style: TextStyle(
                          fontSize: configController.config.value.songFontSize),
                    ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Get.bottomSheet(const FontSettings()),
        child: const Icon(Icons.format_size, color: Colors.white),
      ),
    );
  }
}
