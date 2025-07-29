import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';
import 'package:get/get.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon(
    this.isFavorite, {
    this.number,
    this.size = 24,
    this.onPressed,
    super.key,
  });

  final bool isFavorite;
  final int? number;
  final double size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    
    return IconButton(
      icon: AnimatedCrossFade(
        duration: AppAnimations.medium,
        crossFadeState:
            isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Icon(
          Icons.favorite,
          size: size,
          color: AppColors.favorite,
        ),
        secondChild: Icon(
          Icons.favorite_border,
          size: size,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      onPressed: onPressed ?? () => songsController.toggleFavorite(number),
    );
  }
}
