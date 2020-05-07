import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';
import '../classes/song.dart';
import '../song_display.dart';

class SavedList extends StatelessWidget {
  void _openSong(BuildContext context, int number) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => SongDisplay(number)));
  }

  @override
  Widget build(BuildContext context) {
    final SongsBloc provider = BlocProvider.of<SongsBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Oblíbené'),
        ),
        body: StreamBuilder<Set<int>>(
            stream: provider.stream,
            builder: (_, AsyncSnapshot<Set<int>> snapshot) {
              if (snapshot.data == null) {
                provider.refresh();
                return Center(child: CircularProgressIndicator());
              }
              final songs = provider
                  .getSongs()
                  .where((Song song) => snapshot.data.contains(song.number))
                  .toList();
              return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs.elementAt(index);
                    return ListTile(
                        title: Text('${song.number}. ${song.name}'),
                        onTap: () {
                          _openSong(
                              context,
                              song.number < 198
                                  ? song.number - 1
                                  : song.number - 3);
                        },
                        trailing: FavoriteIcon(song.number));
                  });
            }));
  }
}
