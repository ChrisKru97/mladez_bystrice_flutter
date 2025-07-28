import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_system.dart';

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showShadow;
  final bool useGradient;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.showShadow = true,
    this.useGradient = false,
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
    .fadeIn(duration: AppAnimations.medium)
    .slideY(begin: 0.1, end: 0, duration: AppAnimations.medium);
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
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
    );
  }
}
