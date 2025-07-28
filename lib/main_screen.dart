import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/screens/songs_with_search.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';
import 'package:mladez_zpevnik/components/animated_components.dart';
import 'components/menu_row.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configController = Get.find<ConfigController>();
    Get.find<AnalyticsService>().logScreenView('main_screen');
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
                (isDark ? AppColors.primaryLight : AppColors.primary).withValues(alpha: 0.3),
                (isDark ? AppColors.secondary : AppColors.secondaryLight).withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Mládežový zpěvník',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
            ? AppColors.darkBackgroundGradient
            : AppColors.backgroundGradient,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Main content with animated entrance
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppBorderRadius.lg),
                    topRight: Radius.circular(AppBorderRadius.lg),
                  ),
                  border: Border.all(
                    color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppBorderRadius.lg),
                    topRight: Radius.circular(AppBorderRadius.lg),
                  ),
                  child: const SongsWithSearch(),
                ),
              ),
            ),

            // Enhanced bottom navigation with glassmorphism
            Builder(
              builder: (context) {
                WidgetsBinding.instance.addPersistentFrameCallback((_) {
                  final height = context.size?.height;
                  if (height != null) {
                    configController.bottomBarHeight.value = height;
                  }
                });
                return Container(
                  margin: EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: AppSpacing.md,
                    bottom: AppSpacing.md + MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: isDark 
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: GlassContainer(
                    blur: 15,
                    opacity: isDark ? 0.6 : 0.75,
                    child: const MenuRow(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
