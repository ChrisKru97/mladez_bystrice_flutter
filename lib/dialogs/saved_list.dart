import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/hand_cursor.dart';
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
            leading: HandCursor(child: BackButton()),
            flexibleSpace: SafeArea(
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
                return Center(child: CircularProgressIndicator());
              }
              return SongList(
                  songs: provider
                      .getSongs()
                      .where((Song song) => snapshot.data.contains(song.number))
                      .toList());
            }));
  }
}
