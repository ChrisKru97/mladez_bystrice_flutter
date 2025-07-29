import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/dialogs/create_playlist.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class Playlists extends StatelessWidget {
  const Playlists({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();
    Get.find<AnalyticsService>().logScreenView('playlists');
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
            'Playlisty',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Get.bottomSheet(CreatePlaylist()),
            ),
          ],
        ),
        body: Obx(() => playlistController.playlists.isEmpty
            ? Center(
                child: GestureDetector(
                    onTap: () => Get.bottomSheet(CreatePlaylist()),
                    child:
                        const Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add, size: 50),
                      Text('Přidat'),
                    ])))
            : ListView.separated(
                separatorBuilder: (_, __) => const Divider(
                      height: 2,
                    ),
                itemCount: playlistController.playlists.length,
                itemBuilder: (BuildContext context, int index) {
                  final playlist =
                      playlistController.playlists.elementAt(index);
                  return DismissibleRemove(
                      dismissibleKey: playlist.id,
                      onRemove: () =>
                          playlistController.removePlaylist(playlist.id),
                      confirmDismiss: true,
                      child: ListTile(
                        title: Text(playlist.name,
                            overflow: TextOverflow.ellipsis),
                        trailing: Text('${playlist.songsOrder?.length ?? 0}'),
                        onTap: () =>
                            Get.toNamed('/playlist', arguments: playlist.id),
                      ));
                })));
  }
}
