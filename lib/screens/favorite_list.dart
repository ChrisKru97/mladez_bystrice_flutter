import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/common_app_bar.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/components/song_list_item.dart';
import 'package:mladez_zpevnik/components/song_list_view.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    Get.find<AnalyticsService>().logScreenView('favorite_list');
    
    return Scaffold(
      appBar: const CommonAppBar(title: 'Oblíbené'),
      body: Obx(() {
        final songs = songsController.songs.where((element) => element.isFavorite);
        
        return SongListView(
          songs: songs,
          emptyIcon: Icons.favorite_outline,
          emptyTitle: 'Žádné oblíbené písně',
          emptySubtitle: 'Označte si písně jako oblíbené dlouhým stisknutím',
          customItemBuilder: (song, index) {
            void removeFavorite() => songsController.toggleFavorite(song.number);
            
            return DismissibleRemove(
              onRemove: removeFavorite,
              dismissibleKey: song.number,
              child: SongListItem(
                song: song,
                onLongPress: removeFavorite,
                showFavorite: false,
                trailing: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: removeFavorite,
                      borderRadius: BorderRadius.circular(8),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
