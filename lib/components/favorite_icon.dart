import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:get/get.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon(this.number, {super.key, this.white = false});

  final bool white;
  final int number;

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final favorites = songsController.favorites;
    final isFavorited = favorites.contains(number);
    return Obx(() => IconButton(
        icon: AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          crossFadeState: isFavorited
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: const Icon(Icons.favorite, color: Colors.red),
          secondChild: Icon(Icons.favorite_border,
              color: Theme.of(context).brightness == Brightness.dark || white
                  ? Colors.white
                  : Colors.black),
        ),
        onPressed: () => songsController.toggleFavorite(number)));
  }
}
