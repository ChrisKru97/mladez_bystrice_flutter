import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/classes/song.dart';

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
        body: historyList.isEmpty
            ? Center(
                child: Text('Žádné písně',
                    style: TextStyle(
                        fontSize: 30,
                        color: Get.isDarkMode ? Colors.white : Colors.black)))
            : ListView.separated(
                separatorBuilder: (_, __) => const Divider(
                      height: 2,
                    ),
                itemCount: historyList.length,
                itemBuilder: (BuildContext context, int index) {
                  final element = historyList.elementAt(index);
                  final song = element['song'] as Song?;
                  final openedAt = element["openedAt"] as DateTime;
                  if (song == null) return const Center();
                  return ListTile(
                    title: Text('${song.number}. ${song.name}',
                        overflow: TextOverflow.ellipsis),
                    onTap: () => Get.toNamed('/song', arguments: song.number),
                    trailing: Text(
                        '${openedAt.hour.toString().padLeft(2, '0')}:${openedAt.minute.toString().padLeft(2, '0')} ${openedAt.day}.${openedAt.month}.${openedAt.year - 2000}'),
                  );
                }));
  }
}
