import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class SongsWithSearch extends StatefulWidget {
  const SongsWithSearch({super.key});

  @override
  State<SongsWithSearch> createState() => _SongsWithSearchState();
}

class _SongsWithSearchState extends State<SongsWithSearch>
    with TickerProviderStateMixin {
  late AnimationController _emptyStateController;
  late AnimationController _loadingController;
  
  @override
  void initState() {
    super.initState();
    _emptyStateController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _loadingController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _emptyStateController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

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
                TweenAnimationBuilder<double>(
                  duration: AppAnimations.medium,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    _emptyStateController.value = value;
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: Icon(
                          Icons.search_rounded,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                TweenAnimationBuilder<double>(
                  duration: AppAnimations.medium,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - value) * 10),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          'Žádné výsledky',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.sm),

                TweenAnimationBuilder<double>(
                  duration: AppAnimations.medium,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - value) * 10),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          'Zkuste jiné hledání',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
              TweenAnimationBuilder<double>(
                duration: AppAnimations.medium,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              TweenAnimationBuilder<double>(
                duration: AppAnimations.medium,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Text(
                      'Načítání písní...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
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

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 150 + (index * 20).clamp(0, 200)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, animationValue, child) {
                return Transform.translate(
                  offset: Offset(0, (1 - animationValue) * 10),
                  child: Opacity(
                    opacity: animationValue,
                    child: Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                boxShadow: [isDark ? AppShadows.medium : AppShadows.soft],
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
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
                  splashColor: AppColors.primary.withValues(alpha: 0.1),
                  highlightColor: AppColors.primary.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
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
              ),
                    ),
                  ),
                );
              },
            );
            },
          ),
      ),
    );
  });
}
