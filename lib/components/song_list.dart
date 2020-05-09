import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/bloc_provider.dart';
import 'package:mladez_zpevnik/bloc/songs_bloc.dart';
import '../classes/song.dart';
import '../song_display.dart';
import 'favorite_icon.dart';

class SongList extends StatelessWidget {
  SongList(
      {this.songs,
      this.bottomSheetController,
      this.setBottomSheet,
      this.trimmed = false});

  final ScrollController _controller = ScrollController();
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
        .push(MaterialPageRoute<void>(builder: (_) => SongDisplay(number)));
  }

  @override
  Widget build(BuildContext context) => songs.length > 0
      ? DraggableScrollbar.rrect(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Theme.of(context).secondaryHeaderColor,
          padding: EdgeInsets.only(right: 4, bottom: trimmed ? 80 : 0),
          alwaysVisibleScrollThumb: true,
          labelTextBuilder: (double offset) => Text(
              ((offset ~/ 60) + 1).toString(),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white)),
          controller: _controller,
          child: ListView.separated(
              controller: _controller,
              separatorBuilder: (_, __) => Divider(
                    height: 2,
                    color: Colors.black12,
                  ),
              itemCount: songs.length + (trimmed ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (trimmed && index == songs.length) {
                  return ListTile(title: Container(height: 80));
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
                      _openSong(
                          context,
                          song.number < 198
                              ? song.number - 1
                              : song.number - 3);
                    },
                    trailing: FavoriteIcon(song.number));
              }),
        )
      : Center(
          child: Text('Zatím žádné písně', style: TextStyle(fontSize: 30)));
}
