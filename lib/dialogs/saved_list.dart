import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';
import '../classes/song.dart';
import '../components/song_list.dart';

class SavedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SongsBloc provider = BlocProvider.of<SongsBloc>(context);
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(),
            flexibleSpace: const SafeArea(
                child: Center(
                    child: Text(
              'Oblíbené',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )))),
        body: StreamBuilder<Set<int>>(
            stream: provider.stream,
            builder: (_, AsyncSnapshot<Set<int>> snapshot) {
              if (snapshot.data == null) {
                provider.refresh();
                return const Center(child: CircularProgressIndicator());
              }
              return SongList(
                  songs: provider
                          .getSongs()
                          ?.where((Song song) =>
                              snapshot.data.contains(song.number))
                          ?.toList() ??
                      <Song>[]);
            }));
  }
}
