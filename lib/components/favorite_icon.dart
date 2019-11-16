import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon(this.number);

  final int number;

  @override
  Widget build(BuildContext context) {

    return IconButton(
        icon: Icon(
            favorited
                ? Icons.favorite
                : Icons.favorite_border,
            color: favorited
                ? Colors.red
                : Theme
                .of(context)
                .brightness ==
                Brightness.dark
                ? Colors.white
                : Colors.black),
        onPressed: () {
          if (favorited) {
            ConfigBlocProvider.of(context)
                .removeFavorite(song.number);
          } else {
            ConfigBlocProvider.of(context)
                .addFavorite(song.number);
          }
        })
  }
}