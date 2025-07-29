import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/common_app_bar.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/components/song_list_view.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

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
              child: ListTile(
                title: Text('${song.number}. ${song.name}',
                    overflow: TextOverflow.ellipsis),
                onLongPress: removeFavorite,
                onTap: () {
                  Get.toNamed('/song', arguments: song.number);
                },
                trailing: IconButton(
                    onPressed: removeFavorite,
                    icon: const Icon(Icons.favorite,
                        color: AppColors.favorite, size: 30)),
                contentPadding: const EdgeInsets.only(left: 16, right: 8),
              ),
            );
          },
        );
      }),
    );
  }
}
