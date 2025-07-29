import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/common_app_bar.dart';
import 'package:mladez_zpevnik/components/empty_state.dart';
import 'package:mladez_zpevnik/components/song_list_tile.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')} '
           '${dateTime.day}.${dateTime.month}.${dateTime.year - 2000}';
  }

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
              separatorBuilder: (_, index) => Divider(
                height: 2,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
              itemCount: historyList.length,
              itemBuilder: (BuildContext context, int index) {
                final element = historyList.elementAt(index);
                final songNumber = element['songNumber'] as int;
                final song = songsController.songBox.get(songNumber);
                final openedAt = element["openedAt"] as DateTime;
                
                if (song == null) return const SizedBox.shrink();
                
                return SongListTile(
                  song: song,
                  trailing: Text(
                    _formatDateTime(openedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
