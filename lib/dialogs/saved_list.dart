import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';
import '../classes/song.dart';
import '../components/loader.dart';
import '../components/song_list.dart';

class SavedList extends StatelessWidget {
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
                return Loader();
              }
              return SongList(provider
                  .getSongs()
                  .where((Song song) => snapshot.data.contains(song.number))
                  .toList());
            }));
  }
}
