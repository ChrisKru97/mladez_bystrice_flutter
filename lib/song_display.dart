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
    songsController.getSong(number);
    final song = songsController.openSong;
    final ConfigController configController = Get.find();
    final String title = '${song.value.number}. ${song.value.name}';
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
        behavior: HitTestBehavior.opaque,
        onScaleUpdate: songsController.updateFontScale,
        onScaleEnd: songsController.saveFontSize,
        child: Obx(() {
          final songText = configController.config.value.showChords
              ? song.value.withChords
              : song.value.withoutChords;
          final textStyle = TextStyle(fontSize: song.value.fontSize);
          final alignCenter = configController.config.value.alignCenter;
          final textWidget = Text(
            songText,
            textAlign: alignCenter ? TextAlign.center : TextAlign.left,
            style: textStyle,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: Get.height - Get.statusBarHeight),
                child: textWidget),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Get.bottomSheet(const FontSettings()),
        child: const Icon(Icons.format_size),
      ),
    );
  }
}
