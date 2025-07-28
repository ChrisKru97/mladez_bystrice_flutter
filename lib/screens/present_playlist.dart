import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/helpers/chords_migration.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';

class PresentPlaylist extends StatelessWidget {
  const PresentPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as int;
    final PlaylistController playlistController = Get.find();
    final SongsController songsController = Get.find();
    final ConfigController configController = Get.find();
    final playlist = playlistController.getPlaylist(id);
    Get.find<AnalyticsService>().logPlaylistPresentation(id.toString(), playlist.value.name);
    Get.find<AnalyticsService>().logScreenView('present_playlist');
    return Scaffold(
      appBar: AppBar(title: Text(playlist.value.name)),
      body: GestureDetector(
        onDoubleTap:
            () => configController.config.update((val) {
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
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: playlist.value.songsOrder!.length,
          itemBuilder: (context, index) {
            final songNumber = playlist.value.songsOrder![index];
            final song = songsController.songBox.get(songNumber);
            if (song == null) return const Center();
            final songText = parseAnySongWithChords(song.text).text;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    '${song.number}. ${song.name}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Obx(
                    () => Text(
                      songText,
                      style: TextStyle(
                        fontSize: song.fontSize,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      textAlign:
                          configController.config.value.alignCenter
                              ? TextAlign.center
                              : TextAlign.left,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
