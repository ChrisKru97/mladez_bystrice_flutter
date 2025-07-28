import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';
import 'package:mladez_zpevnik/components/animated_components.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class SongsWithSearch extends StatelessWidget {
  const SongsWithSearch({super.key});

  @override
  Widget build(BuildContext context) => Obx(() {
    final SongsController songsController = Get.find();
    final ConfigController configController = Get.find();
    final songs = songsController.filteredSongs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (songs.isEmpty) {
      if (songsController.searchString.value.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: configController.bottomBarHeight.value + AppSpacing.lg,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 64,
                  color: AppColors.textMuted,
                )
                .animate()
                .scale(duration: AppAnimations.medium)
                .fadeIn(),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Žádné výsledky',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.2, end: 0),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Zkuste jiné hledání',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms)
                .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(
          bottom: configController.bottomBarHeight.value + AppSpacing.lg,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              )
              .animate()
              .scale(duration: AppAnimations.medium),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'Načítání písní...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        Get.find<AnalyticsService>().logEvent(
          name: 'refresh_songs_list',
          parameters: {'count': songs.length},
        );
        return await songsController.loadSongs(force: true);
      },
      color: AppColors.primary,
      child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 10,
          radius: const Radius.circular(4.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: AppSpacing.xs,
              left: AppSpacing.xs,
              right: AppSpacing.xs,
              bottom: configController.bottomBarHeight.value + AppSpacing.sm,
            ),
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int index) {
            final song = songs.elementAt(index);

            return AnimatedCard(
                    margin: const EdgeInsets.only(bottom: 6.0),
                    useGradient: false,
                    onTap: () {
                      songsController.addToHistory(song.number);
                      Get.find<AnalyticsService>().logSongView(
                        song.number.toString(),
                        song.name,
                      );
                      Get.toNamed('/song', arguments: song.number);
                    },
                    child: InkWell(
                      onTap: () {
                        songsController.addToHistory(song.number);
                        Get.find<AnalyticsService>().logSongView(
                          song.number.toString(),
                          song.name,
                        );
                        Get.toNamed('/song', arguments: song.number);
                      },
                      onLongPress: () {
                        songsController.toggleFavorite(song.number);
                        final analyticsService = Get.find<AnalyticsService>();
                        if (song.isFavorite) {
                          analyticsService.logRemoveFromFavorites(
                            song.number.toString(),
                            song.name,
                          );
                        } else {
                          analyticsService.logAddToFavorites(
                            song.number.toString(),
                            song.name,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            // Song number with modern styling
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                boxShadow: [AppShadows.soft],
                              ),
                              child: Center(
                                child: Text(
                                  '${song.number}',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8.0),

                            // Song name and details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.textLight : AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),

                            // Enhanced favorite icon
                            Container(
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: song.isFavorite
                                  ? AppColors.favorite.withValues(alpha: 0.1)
                                  : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                              ),
                              child: FavoriteIcon(song.isFavorite, number: song.number),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate(delay: Duration(milliseconds: index * 50))
                   .fadeIn(duration: AppAnimations.medium)
                   .slideY(begin: 0.3, end: 0, duration: AppAnimations.medium);
            },
          ),
      ),
    );
  });
}
