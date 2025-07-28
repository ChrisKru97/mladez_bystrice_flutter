import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_system.dart';

// Animated Card Component
class AnimatedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showShadow;
  final bool useGradient;
  final Duration animationDuration;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.showShadow = true,
    this.useGradient = false,
    this.animationDuration = AppAnimations.medium,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: useGradient
                ? (isDark ? AppColors.darkCardGradient : AppColors.cardGradient)
                : null,
              color: useGradient ? null : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              boxShadow: showShadow ? [
                isDark ? AppShadows.medium : AppShadows.soft,
              ] : null,
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: animationDuration)
    .slideY(begin: 0.1, end: 0, duration: animationDuration)
    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}

// Animated Button Component
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isPrimary;
  final EdgeInsetsGeometry? padding;
  final double? width;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isPrimary = true,
    this.padding,
    this.width,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.width,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isPrimary
                    ? AppColors.primary
                    : AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: widget.padding ?? const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  elevation: 0,
                ),
                child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(widget.text),
                      ],
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Floating Action Button with Animation
class AnimatedFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final bool mini;

  const AnimatedFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      mini: mini,
      child: Icon(icon),
    )
    .animate()
    .scale(
      begin: const Offset(0, 0),
      end: const Offset(1, 1),
      duration: AppAnimations.medium,
      curve: AppAnimations.bounceOut,
    )
    .fadeIn(duration: AppAnimations.medium);
  }
}

// Glass Morphism Container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4), 
              width: 2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: opacity * 0.9),
                Colors.white.withValues(alpha: opacity * 0.7),
              ],
            ),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Animated List Item
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    )
    .animate()
    .fadeIn(
      delay: Duration(milliseconds: index * 50),
      duration: AppAnimations.medium,
    )
    .slideX(
      begin: 0.2,
      end: 0,
      delay: Duration(milliseconds: index * 50),
      duration: AppAnimations.medium,
    );
  }
}

// Shimmer Loading Effect
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.sm),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(
      duration: const Duration(milliseconds: 1500),
      color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
    );
  }
}

// Pulse Animation Widget
class PulseAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  Widget build(BuildContext context) {
    return child
      .animate(onPlay: (controller) => controller.repeat(reverse: true))
      .scale(
        begin: Offset(minScale, minScale),
        end: Offset(maxScale, maxScale),
        duration: duration,
        curve: AppAnimations.easeInOut,
      );
  }
}

// Slide Transition Widget
class SlideTransition extends StatelessWidget {
  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Curve curve;

  const SlideTransition({
    super.key,
    required this.child,
    this.begin = const Offset(1.0, 0.0),
    this.end = Offset.zero,
    this.duration = AppAnimations.medium,
    this.curve = AppAnimations.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return child
      .animate()
      .slideX(
        begin: begin.dx,
        end: end.dx,
        duration: duration,
        curve: curve,
      )
      .slideY(
        begin: begin.dy,
        end: end.dy,
        duration: duration,
        curve: curve,
      );
  }
}
