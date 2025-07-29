import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/song_list_view.dart';

class SongsWithSearch extends StatefulWidget {
  const SongsWithSearch({super.key});

  @override
  State<SongsWithSearch> createState() => _SongsWithSearchState();
}

class _SongsWithSearchState extends State<SongsWithSearch> {

  @override
  Widget build(BuildContext context) => Obx(() {
    final SongsController songsController = Get.find();
    final ConfigController configController = Get.find();
    final songs = songsController.filteredSongs;

    return SongListView(
      songs: songs,
      isLoading: songs.isEmpty && songsController.searchString.value.isEmpty,
      loadingMessage: 'Načítání písní...',
      emptyIcon: Icons.search_rounded,
      emptyTitle: 'Žádné výsledky',
      emptySubtitle: 'Zkuste jiné hledání',
      bottomPadding: configController.bottomBarHeight.value,
      showRefreshIndicator: true,
      onRefresh: () => songsController.loadSongs(force: true),
    );
  });
}
