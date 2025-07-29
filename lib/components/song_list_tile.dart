import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.trailing,
    this.subtitle,
    this.contentPadding,
  });

  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final Widget? subtitle;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${song.number}. ${song.name}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap ?? () => Get.toNamed('/song', arguments: song.number),
      onLongPress: onLongPress,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}