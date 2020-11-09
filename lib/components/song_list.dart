import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';
import '../classes/song.dart';
import '../dialogs/add_song.dart';
import '../song_display.dart';
import 'favorite_icon.dart';

class SongList extends StatelessWidget {
  SongList(
      {required this.songs,
      this.bottomSheetController,
      this.setBottomSheet,
      this.trimmed = false});

  final ScrollController _controller = ScrollController();
  final bool trimmed;
  final List<Song> songs;
  final PersistentBottomSheetController<int>? bottomSheetController;
  final void Function(PersistentBottomSheetController<int>?)? setBottomSheet;

  void _openSong(BuildContext context, int number) {
    try {
      BlocProvider.of<SongsBloc>(context)!.addToHistory(number);
      bottomSheetController?.close();
      if (setBottomSheet != null) {
        setBottomSheet!(null);
      }
    } on Exception catch (_) {}
    Navigator.of(context)!
        .push(CupertinoPageRoute<void>(builder: (_) => SongDisplay(number)));
  }

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Center(
          child: Text('Zatím žádné písně', style: TextStyle(fontSize: 30)));
    }
    final Widget list = DraggableScrollbar.rrect(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Theme.of(context).secondaryHeaderColor,
        padding: EdgeInsets.only(right: 4, bottom: trimmed ? 80 : 0),
        alwaysVisibleScrollThumb: true,
        controller: _controller,
        child: ListView.separated(
            controller: _controller,
            separatorBuilder: (_, __) => const Divider(
                  height: 2,
                  color: Colors.black12,
                ),
            itemCount: songs.length + (trimmed ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (trimmed && index == songs.length) {
                return ListTile(title: Container(height: 70));
              }
              final Song song = songs.elementAt(index);
              return ListTile(
                  title: Text(
                    '${song.number}. ${song.name}',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  onTap: () {
                    _openSong(context,
                        song.number < 198 ? song.number - 1 : song.number - 3);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!kReleaseMode)
                        IconButton(
                          color: Colors.black,
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.of(context)!.push(
                              CupertinoPageRoute<void>(
                                  builder: (BuildContext _) {
                            final String chordsText =
                                (BlocProvider.of<SongsBloc>(context)!
                                        .getSong(
                                            song.number > 196
                                                ? song.number - 3
                                                : song.number - 1,
                                            showChords: true)
                                        ?.song) ??
                                    '';
                            return AddSong(context,
                                song: song, chordsText: chordsText);
                          })),
                        ),
                      FavoriteIcon(song.number),
                    ],
                  ));
            }));
    if (!trimmed) {
      return list;
    }
    return RefreshIndicator(
        onRefresh: () async {
          final SongsBloc blocProvider = BlocProvider.of<SongsBloc>(context)!;
          // ignore: unnecessary_cast
          return Future.wait(<Future<void>>[
            blocProvider.loadNoChordSongs(force: true),
            blocProvider.loadChordSongs(force: true)
          ]) as Future<void>;
        },
        child: list);
  }
}
