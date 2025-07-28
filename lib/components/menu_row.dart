import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/search_info.dart';
import 'package:mladez_zpevnik/dialogs/number_select.dart';
import 'package:mladez_zpevnik/dialogs/search_song.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class ModernNavButton extends StatefulWidget {
  const ModernNavButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.isActive = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final bool isActive;

  @override
  State<ModernNavButton> createState() => _ModernNavButtonState();
}

class _ModernNavButtonState extends State<ModernNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: widget.isActive || _isPressed
                    ? AppColors.primaryGradient
                    : LinearGradient(
                        colors: [
                          isDark ? AppColors.cardDark : Colors.white,
                          isDark ? AppColors.surfaceDark : AppColors.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                boxShadow: [
                  if (!_isPressed) ...[
                    AppShadows.medium,
                    BoxShadow(
                      color: widget.isActive
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : (isDark
                                ? Colors.black.withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.1)),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ],
                border: Border.all(
                  color: widget.isActive
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1)),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: widget.isActive || _isPressed
                      ? Colors.white
                      : (isDark
                            ? AppColors.textLight
                            : AppColors.textSecondary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final buttonList = [
  {
    'icon': Icons.favorite_outline,
    'label': 'Oblíbené',
    'onPressed': () {
      Get.find<AnalyticsService>().logScreenView('favorites');
      Get.toNamed('/favorite');
    },
  },
  {
    'icon': Icons.search_rounded,
    'label': 'Hledat',
    'onPressed': () {
      final songsController = Get.find<SongsController>();
      songsController.searchString.value = '';
      Get.find<AnalyticsService>().logEvent(name: 'open_search');
      Get.bottomSheet(const SearchSong());
    },
  },
  {
    'icon': Icons.numbers,
    'label': 'Číslo',
    'onPressed': () {
      Get.find<AnalyticsService>().logEvent(name: 'open_number_select');
      Get.bottomSheet(NumberSelect());
    },
  },
  {
    'icon': Icons.history_rounded,
    'label': 'Historie',
    'onPressed': () {
      Get.find<AnalyticsService>().logScreenView('history');
      Get.toNamed('/history');
    },
  },
  {
    'icon': Icons.playlist_play_rounded,
    'label': 'Playlisty',
    'onPressed': () {
      Get.find<AnalyticsService>().logScreenView('playlists');
      Get.toNamed('/playlists');
    },
  },
];

class MenuRow extends StatelessWidget {
  const MenuRow({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced search info with modern styling
          Container(
                margin: const EdgeInsets.only(bottom: 2.0),
                child: const SearchInfo(),
              )
              .animate()
              .fadeIn(duration: AppAnimations.medium)
              .slideY(begin: 0.3, end: 0),

          // Modern navigation buttons with staggered animations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttonList.asMap().entries.map((entry) {
              final index = entry.key;
              final button = entry.value;
              final isActive = _isButtonActive(currentRoute, index);

              return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ModernNavButton(
                            icon: button['icon'] as IconData,
                            onPressed: button['onPressed'] as VoidCallback,
                            label: button['label'] as String?,
                            isActive: isActive,
                          ),

                          const SizedBox(height: 2.0),

                          // Button label
                          Text(
                            button['label'] as String,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isActive
                                      ? AppColors.primary
                                      : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.textLight
                                            : AppColors.textPrimary),
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    duration: AppAnimations.medium,
                  )
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    duration: AppAnimations.medium,
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    duration: AppAnimations.medium,
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _isButtonActive(String currentRoute, int buttonIndex) {
    switch (buttonIndex) {
      case 0: // Favorites
        return currentRoute == '/favorite';
      case 1: // Search
        return false; // Search is a modal, not a route
      case 2: // Number select
        return false; // Number select is a modal, not a route
      case 3: // History
        return currentRoute == '/history';
      case 4: // Playlists
        return currentRoute == '/playlists' || currentRoute == '/playlist';
      default:
        return false;
    }
  }
}
