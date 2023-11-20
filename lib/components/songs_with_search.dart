import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

import 'song_list.dart';

class SongsWithSearch extends StatelessWidget {
  const SongsWithSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();

    return Obx(() => SongList(trimmed: true, songs: songsController.filteredSongs));
  }
}
