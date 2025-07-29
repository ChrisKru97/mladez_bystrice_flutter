import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/components/empty_state.dart';
import 'package:mladez_zpevnik/components/loading_state.dart';
import 'package:mladez_zpevnik/components/song_list_item.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class SongListView extends StatelessWidget {
  const SongListView({
    super.key,
    required this.songs,
    this.emptyIcon = Icons.music_note_outlined,
    this.emptyTitle = 'Žádné písně',
    this.emptySubtitle = 'Žádné písně k zobrazení',
    this.onRefresh,
    this.isLoading = false,
    this.loadingMessage = 'Načítání...',
    this.bottomPadding = 0,
    this.customItemBuilder,
    this.showRefreshIndicator = false,
  });

  final Iterable<Song> songs;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final String loadingMessage;
  final double bottomPadding;
  final Widget Function(Song song, int index)? customItemBuilder;
  final bool showRefreshIndicator;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingState(
        message: loadingMessage,
        bottomPadding: bottomPadding,
      );
    }

    if (songs.isEmpty) {
      return EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: emptySubtitle,
        bottomPadding: bottomPadding,
      );
    }

    final listView = ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.xs,
        left: AppSpacing.xs,
        right: AppSpacing.xs,
        bottom: bottomPadding + AppSpacing.sm,
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs.elementAt(index);
        if (customItemBuilder != null) {
          return customItemBuilder!(song, index);
        }
        return SongListItem(song: song);
      },
    );

    if (showRefreshIndicator && onRefresh != null) {
      return RefreshIndicator.adaptive(
        onRefresh: () async {
          Get.find<AnalyticsService>().logEvent(
            name: 'refresh_songs_list',
            parameters: {'count': songs.length},
          );
          return await onRefresh!();
        },
        color: AppColors.primary,
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 10,
          radius: const Radius.circular(4.0),
          child: listView,
        ),
      );
    }

    return listView;
  }
}