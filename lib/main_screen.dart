import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/screens/songs_with_search.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';
import 'package:mladez_zpevnik/components/animated_components.dart';
import 'package:mladez_zpevnik/components/common_app_bar.dart';
import 'package:mladez_zpevnik/components/gradient_background.dart';
import 'components/menu_row.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configController = Get.find<ConfigController>();
    Get.find<AnalyticsService>().logScreenView('main_screen');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Mládežový zpěvník',
        toolbarHeight: 36,
      ),
      body: GradientBackground(
        withGlassContainer: true,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Main content with animated entrance
            const Positioned.fill(
              child: SongsWithSearch(),
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
                    bottom: MediaQuery.of(
                      context,
                    ).padding.bottom.clamp(AppSpacing.xs, double.infinity),
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
                    opacity: isDark ? 0.4 : 1,
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
