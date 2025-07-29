import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    Get.find<AnalyticsService>().logScreenView('favorite_list');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
          elevation: 0,
          toolbarHeight: 48,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isDark ? AppColors.primaryLight : AppColors.primary)
                      .withValues(alpha: 0.3),
                  (isDark ? AppColors.secondary : AppColors.secondaryLight)
                      .withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            'Oblíbené',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
        ),
        body: Obx(() {
          final songs =
              songsController.songs.where((element) => element.isFavorite);
          if (songs.isEmpty) {
            return Center(
                child: Text('Žádné písně',
                    style: TextStyle(
                        fontSize: 20,
                        color: Get.isDarkMode ? Colors.white : Colors.black)));
          }
          return ListView.separated(
              separatorBuilder: (_, __) => const Divider(
                    height: 2,
                  ),
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                final song = songs.elementAt(index);
                removeFavorite() => songsController.toggleFavorite(song.number);
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
                              color: redColor, size: 30)),
                      contentPadding: const EdgeInsets.only(left: 16, right: 8),
                    ));
              });
        }));
  }
}
