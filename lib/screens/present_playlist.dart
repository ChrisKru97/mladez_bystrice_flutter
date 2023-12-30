import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

class PresentPlaylist extends StatelessWidget {
  const PresentPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as int;
    final PlaylistController playlistController = Get.find();
    final SongsController songsController = Get.find();
    final ConfigController configController = Get.find();
    final playlist = playlistController.getPlaylist(id);
    return Scaffold(
        appBar: AppBar(title: Text(playlist.value.name)),
        body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: playlist.value.songsOrder!.length,
            itemBuilder: (context, index) {
              final songNumber = playlist.value.songsOrder![index];
              final song = songsController.songBox.get(songNumber);
              if (song == null) return const Center();
              final songText = configController.config.value.showChords
                  ? song.withChords
                  : song.withoutChords;
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text('${song.number}. ${song.name}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(songText,
                      style: TextStyle(
                          fontSize: song.fontSize,
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                      textAlign: configController.config.value.alignCenter
                          ? TextAlign.center
                          : TextAlign.left),
                )
              ]);
            }));
  }
}
