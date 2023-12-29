import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/song_list.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final historyList = songsController.historyList();
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(),
            title: const Text(
              'Naposledy otevřené',
            )),
        body: SongList(historyList: historyList));
  }
}
