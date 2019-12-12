import 'package:flutter/material.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';
import 'components/floating_button.dart';
import 'components/loader.dart';
import 'components/song_list.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return StreamBuilder<Config>(
        stream: provider.stream,
        builder: (_, AsyncSnapshot<Config> snapshot) {
          if (snapshot.data == null) {
            provider.refresh();
            return Container(color: Colors.white, child: Loader());
          }
          final SongsBloc songsProvider = BlocProvider.of<SongsBloc>(context);
          final List<Song> songs =
              songsProvider.getSongs();
          if (songs == null) {
            provider.refresh();
            return Container(color: Colors.white, child: Loader());
          }
          return StreamBuilder<String>(
              stream: BlocProvider.of<SearchBloc>(context).stream,
              initialData: null,
              builder: (_, AsyncSnapshot<String> snapshot) {
                List<Song> filteredSongs;
                if (snapshot.data != null && snapshot.data.isNotEmpty) {
                  filteredSongs = songs
                      .where((Song song) =>
                          song.name
                              .toLowerCase()
                              .contains(snapshot.data.toLowerCase()) ||
                          song.song
                              .toLowerCase()
                              .contains(snapshot.data.toLowerCase()) ||
                          song.number
                              .toString()
                              .contains(snapshot.data.toLowerCase()))
                      .toList();
                } else {
                  filteredSongs = songs;
                }
                return Scaffold(
                  body: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        StreamBuilder<Set<int>>(
                            stream: BlocProvider.of<SongsBloc>(context).stream,
                            initialData: const <int>{},
                            builder: (_, AsyncSnapshot<Set<int>> snapshot) =>
                                SongList(filteredSongs))
                      ]),
                  floatingActionButton: FloatingButton(),
                );
              });
        });
  }
}
