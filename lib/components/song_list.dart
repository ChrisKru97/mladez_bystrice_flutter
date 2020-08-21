import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/bloc_provider.dart';
import 'package:mladez_zpevnik/bloc/songs_bloc.dart';
import 'package:mladez_zpevnik/components/hand_cursor.dart';
import 'package:mladez_zpevnik/dialogs/add_song.dart';
import '../classes/song.dart';
import '../song_display.dart';
import 'favorite_icon.dart';

class SongList extends StatelessWidget {
  SongList(
      {this.songs,
      this.bottomSheetController,
      this.setBottomSheet,
      this.trimmed = false});

  final bool trimmed;
  final List<Song> songs;
  final PersistentBottomSheetController bottomSheetController;
  final void Function(PersistentBottomSheetController) setBottomSheet;

  void _openSong(BuildContext context, int number) {
    try {
      BlocProvider.of<SongsBloc>(context).addToHistory(number);
      if (bottomSheetController != null) {
        bottomSheetController.close();
        setBottomSheet(null);
      }
    } catch (_) {}
    Navigator.of(context)
        .push(CupertinoPageRoute<void>(builder: (_) => SongDisplay(number)));
  }

  @override
  Widget build(BuildContext context) {
    if (songs.length == 0)
      return Center(
          child: Text('Zatím žádné písně', style: TextStyle(fontSize: 30)));
    final list = ListView.separated(
        separatorBuilder: (_, __) => Divider(
              height: 2,
              color: Colors.black12,
            ),
        itemCount: songs.length + (trimmed ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (trimmed && index == songs.length) {
            return ListTile(title: Container(height: 70));
          }
          final Song song = songs.elementAt(index);
          return HandCursor(
            child: ListTile(
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
                  children: [
                    if (!kReleaseMode)
                      IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.of(context).push(
                            CupertinoPageRoute<void>(builder: (BuildContext _) {
                          final chordsText = BlocProvider.of<SongsBloc>(context)
                              .getSong(
                                  song.number > 196
                                      ? song.number - 3
                                      : song.number - 1,
                                  showChords: true)
                              .song;
                          return AddSong(context,
                              song: song, chordsText: chordsText);
                        })),
                      ),
                    FavoriteIcon(song.number),
                  ],
                )),
          );
        });
    if (!trimmed) return list;
    return RefreshIndicator(
        onRefresh: () async {
          final blocProvider = BlocProvider.of<SongsBloc>(context);
          return Future.wait([
            blocProvider.loadNoChordSongs(force: true),
            blocProvider.loadChordSongs(force: true)
          ]);
        },
        child: list);
  }
}
