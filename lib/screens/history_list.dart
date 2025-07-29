import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/components/common_app_bar.dart';
import 'package:mladez_zpevnik/components/song_list_item.dart';
import 'package:mladez_zpevnik/components/song_list_view.dart';
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
    
    // Convert history list to songs with timestamps
    final songsWithTimestamps = historyList
        .map((element) {
          final songNumber = element['songNumber'] as int;
          final song = songsController.songBox.get(songNumber);
          final openedAt = element["openedAt"] as DateTime;
          return song != null ? {'song': song, 'timestamp': openedAt} : null;
        })
        .where((item) => item != null)
        .cast<Map<String, dynamic>>();
    
    return Scaffold(
      appBar: const CommonAppBar(title: 'Naposledy otevřené'),
      body: SongListView(
        songs: songsWithTimestamps.map((item) => item['song'] as Song),
        emptyIcon: Icons.history_rounded,
        emptyTitle: 'Žádná historie',
        emptySubtitle: 'Zatím jste neotevřeli žádné písně',
        customItemBuilder: (song, index) {
          final timestamp = songsWithTimestamps.elementAt(index)['timestamp'] as DateTime;
          
          return _HistorySongItem(
            song: song,
            timestamp: timestamp,
            formatDateTime: _formatDateTime,
          );
        },
      ),
    );
  }
}

class _HistorySongItem extends StatelessWidget {
  const _HistorySongItem({
    required this.song,
    required this.timestamp,
    required this.formatDateTime,
  });

  final Song song;
  final DateTime timestamp;
  final String Function(DateTime) formatDateTime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SongListItem(song: song, showFavorite: false),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Text(
              formatDateTime(timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
