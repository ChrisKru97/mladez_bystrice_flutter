import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final historyList = songsController.historyList();
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          'Naposledy otevřené',
        )),
        body: historyList?.isNotEmpty == true
            ? ListView.separated(
                separatorBuilder: (_, __) => const Divider(
                      height: 2,
                    ),
                itemCount: historyList!.length,
                itemBuilder: (BuildContext context, int index) {
                  final songNumber = historyList.elementAt(index);
                  final song = songsController.songs
                      .firstWhereOrNull((song) => song.number == songNumber);
                  if (song == null) return const Center();
                  return ListTile(
                    title: Text('${song.number}. ${song.name}',
                        overflow: TextOverflow.ellipsis),
                    onTap: () => Get.toNamed('/song', arguments: song.number),
                  );
                })
            : Center(
                child: Text('Žádné písně',
                    style: TextStyle(
                        fontSize: 30,
                        color: Get.isDarkMode ? Colors.white : Colors.black))));
  }
}
