import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class SongListItem extends StatelessWidget {
  const SongListItem({
    super.key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.showFavorite = true,
    this.trailing,
  });

  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showFavorite;
  final Widget? trailing;

  void _handleTap() {
    if (onTap != null) {
      onTap!();
    } else {
      Get.toNamed('/song', arguments: song.number);
    }
  }

  void _handleLongPress() {
    if (onLongPress != null) {
      onLongPress!();
    } else {
      final songsController = Get.find<SongsController>();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
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
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: (trailing == null && !showFavorite) ? AppSpacing.sm : AppSpacing.xs,
            ),
            child: Row(
              children: [
                // Song number with modern styling
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withAlpha(100),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    boxShadow: [AppShadows.soft],
                  ),
                  child: Center(
                    child: Text(
                      '${song.number}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textLight : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
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

                // Trailing widget (favorite icon or custom)
                if (trailing != null)
                  trailing!
                else if (showFavorite)
                  Container(
                    height: 40,
                    width: 40,
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
    );
  }
}