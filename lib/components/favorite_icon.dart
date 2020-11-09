import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon(this.number, {this.white = false});

  final bool white;
  final int number;

  @override
  Widget build(BuildContext context) {
    final SongsBloc provider = BlocProvider.of<SongsBloc>(context)!;
    return StreamBuilder<Set<int>>(
        stream: provider.stream,
        builder: (_, AsyncSnapshot<Set<int>> snapshot) {
          if (snapshot.data == null) {
            provider.refresh();
          }
          final bool favorited = snapshot.data?.contains(number) ?? false;
          return IconButton(
              icon: AnimatedCrossFade(
                duration: const Duration(milliseconds: 400),
                crossFadeState: favorited
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: const Icon(Icons.favorite, color: Colors.red),
                secondChild: Icon(Icons.favorite_border,
                    color:
                        Theme.of(context).brightness == Brightness.dark || white
                            ? Colors.white
                            : Colors.black),
              ),
              onPressed: () {
                if (favorited) {
                  provider.removeFavorite(number);
                } else {
                  provider.addFavorite(number);
                }
              });
        });
  }
}
