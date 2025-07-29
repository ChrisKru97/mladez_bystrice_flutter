import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.toolbarHeight = 48,
  });

  final String title;
  final List<Widget>? actions;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
      elevation: 0,
      toolbarHeight: toolbarHeight,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (isDark ? AppColors.primaryLight : AppColors.primary)
                  .withValues(alpha: 0.3),
              (isDark ? AppColors.secondary : AppColors.secondaryLight)
                  .withValues(alpha: 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: FittedBox(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}