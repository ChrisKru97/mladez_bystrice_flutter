import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;

  @override
  State<ModernNavButton> createState() => _ModernNavButtonState();
}

class _ModernNavButtonState extends State<ModernNavButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverScaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.fastOutSlowIn),
    );
    _hoverScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
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

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _hoverScaleAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value * _hoverScaleAnimation.value,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: _isPressed
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
                        color: isDark
                                  ? Colors.black.withValues(
                                      alpha: _isHovered ? 0.6 : 0.4,
                                    )
                                  : Colors.black.withValues(
                                      alpha: _isHovered ? 0.15 : 0.1,
                                    ),
                        blurRadius: _isHovered ? 16 : 12,
                        offset: Offset(0, _isHovered ? 6 : 4),
                      ),
                    ],
                  ],
                  border: Border.all(
                    color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: _isPressed
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

class MenuRow extends StatefulWidget {
  const MenuRow({super.key});

  @override
  State<MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<MenuRow> with TickerProviderStateMixin {
  late AnimationController _searchInfoController;
  late AnimationController _buttonsController;
  late Animation<double> _searchInfoFadeAnimation;
  late Animation<double> _searchInfoSlideAnimation;

  @override
  void initState() {
    super.initState();

    _searchInfoController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _buttonsController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );

    _searchInfoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchInfoController,
        curve: AppAnimations.fastOutSlowIn,
      ),
    );

    _searchInfoSlideAnimation = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _searchInfoController,
        curve: AppAnimations.fastOutSlowIn,
      ),
    );

    // Start animations with slight delay
    _searchInfoController.forward();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) _buttonsController.forward();
    });
  }

  @override
  void dispose() {
    _searchInfoController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Enhanced search info with modern styling
        AnimatedBuilder(
          animation: _searchInfoController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _searchInfoSlideAnimation.value * 20),
              child: Opacity(
                opacity: _searchInfoFadeAnimation.value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 2.0),
                  child: const SearchInfo(),
                ),
              ),
            );
          },
        ),

        // Modern navigation buttons with staggered animations
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttonList.asMap().entries.map((entry) {
            final index = entry.key;
            final button = entry.value;

            return Expanded(
              child: AnimatedBuilder(
                animation: _buttonsController,
                builder: (context, child) {
                  // Stagger the animation based on index
                  final delayFactor = (index * 0.05).clamp(0.0, 0.8);
                  final adjustedProgress =
                      (_buttonsController.value - delayFactor).clamp(0.0, 1.0) /
                      (1.0 - delayFactor);

                  final fadeValue = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).transform(adjustedProgress);
                  final slideValue = Tween<double>(
                    begin: 0.3,
                    end: 0.0,
                  ).transform(adjustedProgress);
                  final scaleValue = Tween<double>(
                    begin: 0.9,
                    end: 1.0,
                  ).transform(adjustedProgress);

                  return Transform.scale(
                    scale: scaleValue,
                    child: Transform.translate(
                      offset: Offset(0, slideValue * 10),
                      child: Opacity(
                        opacity: fadeValue,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ModernNavButton(
                                icon: button['icon'] as IconData,
                                onPressed: button['onPressed'] as VoidCallback,
                                label: button['label'] as String?,
                              ),

                              const SizedBox(height: 2.0),

                              // Button label
                              Text(
                                button['label'] as String,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.textLight
                                                : AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}
