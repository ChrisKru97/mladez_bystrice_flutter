import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';
import '../components/song_list.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SongsBloc provider = BlocProvider.of<SongsBloc>(context);
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(),
            flexibleSpace: const SafeArea(
                child: Center(
                    child: Text(
              'Naposledy otevřené',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )))),
        body: StreamBuilder<List<int>>(
            stream: provider.historyStream,
            builder: (_, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.data == null) {
                provider.refresh();
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              return SongList(
                  songs: snapshot.data!.map(provider.getSong).toList());
            }));
  }
}
