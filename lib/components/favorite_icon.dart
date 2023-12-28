import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:get/get.dart';

const redColor = Color.fromRGBO(240, 149, 142, 1);

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon(this.isFavorite, {this.number, super.key});

  final bool isFavorite;
  final int? number;

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    return IconButton(
        icon: AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          crossFadeState:
              isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: const Icon(Icons.favorite, size: 30, color: redColor),
          secondChild: const Icon(Icons.favorite_border, size: 30),
        ),
        onPressed: () => songsController.toggleFavorite(number));
  }
}
