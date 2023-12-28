import 'dart:async';
import 'dart:core';

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
    final song = songsController.getSong(number);
    final ConfigController configController = Get.find();
    final String title = '${song.value.number}. ${song.value.name}';

    Timer? hideFabFuture;
    void setHideFabTimer(Rx<bool> showFab) {
      hideFabFuture?.cancel();
      hideFabFuture = Timer(const Duration(seconds: 2), () {
        showFab.value = false;
      });
    }

    return ObxValue((showFab) {
      setHideFabTimer(showFab);
      return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              title,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          actions: <Widget>[Obx(() => FavoriteIcon(song.value.isFavorite))],
        ),
        body: GestureDetector(
          onTapDown: (_) {
            showFab.value = true;
          },
          behavior: HitTestBehavior.opaque,
          onScaleUpdate: songsController.updateFontScale,
          onScaleEnd: songsController.saveFontSize,
          onDoubleTap: () => configController.config.update((val) {
            if (val == null) return;
            val.showChords = !val.showChords;
          }),
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta != null &&
                (details.primaryDelta! > 15 || details.primaryDelta! < -15)) {
              configController.config.update((val) {
                if (val == null) return;
                val.alignCenter = details.primaryDelta! > 0;
              });
            }
          },
          child: Obx(() {
            final songText = configController.config.value.showChords
                ? song.value.withChords
                : song.value.withoutChords;
            final textStyle = TextStyle(
                fontSize: song.value.fontSize,
                color: Get.isDarkMode ? Colors.white : Colors.black);
            final alignCenter = configController.config.value.alignCenter;
            final textWidget = Text(
              songText,
              textAlign: alignCenter ? TextAlign.center : TextAlign.left,
              style: textStyle,
            );
            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: Get.height - Get.statusBarHeight,
                      minWidth: Get.width),
                  child: textWidget),
            );
          }),
        ),
        floatingActionButton: showFab.value
            ? FloatingActionButton(
                mini: true,
                onPressed: () => Get.bottomSheet(const FontSettings()),
                child: const Icon(Icons.format_size),
              )
            : null,
      );
    }, true.obs);
  }
}
