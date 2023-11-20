import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:get/get.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon(this.isFavorite, this.number,
      {super.key, this.white = false});

  final bool isFavorite;
  final bool white;
  final int number;

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    return IconButton(
        icon: AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          crossFadeState:
              isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: const Icon(Icons.favorite, color: Colors.red),
          secondChild: const Icon(Icons.favorite_border),
        ),
        onPressed: () => songsController.toggleFavorite(number));
  }
}
