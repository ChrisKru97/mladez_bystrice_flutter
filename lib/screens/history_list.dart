import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/common_app_bar.dart';
import 'package:mladez_zpevnik/components/empty_state.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final historyList = songsController.historyList();
    Get.find<AnalyticsService>().logScreenView('history_list');
    
    return Scaffold(
      appBar: const CommonAppBar(title: 'Naposledy otevřené'),
      body: historyList.isEmpty
          ? const EmptyState(
              icon: Icons.history_rounded,
              title: 'Žádná historie',
              subtitle: 'Zatím jste neotevřeli žádné písně',
            )
          : ListView.separated(
              separatorBuilder: (_, index) => const Divider(height: 2),
              itemCount: historyList.length,
              itemBuilder: (BuildContext context, int index) {
                final element = historyList.elementAt(index);
                final songNumber = element['songNumber'] as int;
                final song = songsController.songBox.get(songNumber);
                final openedAt = element["openedAt"] as DateTime;
                if (song == null) return const SizedBox.shrink();
                return ListTile(
                  title: Text('${song.number}. ${song.name}',
                      overflow: TextOverflow.ellipsis),
                  onTap: () => Get.toNamed('/song', arguments: song.number),
                  trailing: Text(
                      '${openedAt.hour.toString().padLeft(2, '0')}:${openedAt.minute.toString().padLeft(2, '0')} ${openedAt.day}.${openedAt.month}.${openedAt.year - 2000}'),
                );
              },
            ),
    );
  }
}
