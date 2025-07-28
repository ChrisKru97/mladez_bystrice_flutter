import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class AnimatedCard extends StatefulWidget {
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
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.fastOutSlowIn,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 0.05,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.fastOutSlowIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 10),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: widget.margin ?? const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      gradient: widget.useGradient
                        ? (isDark ? AppColors.darkCardGradient : AppColors.cardGradient)
                        : null,
                      color: widget.useGradient ? null : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      boxShadow: widget.showShadow ? [
                        isDark ? AppShadows.medium : AppShadows.soft,
                      ] : null,
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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
