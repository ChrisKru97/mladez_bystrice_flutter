import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import '../classes/song.dart';
import '../song_display.dart';
import 'favorite_icon.dart';

class SongList extends StatelessWidget {
  SongList(this.songs, {Key key}) : super(key: key);

  final ScrollController _controller = ScrollController();
  final List<Song> songs;

  void _openSong(BuildContext context, int number) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => SongDisplay(number)));
  }

  @override
  Widget build(BuildContext context) => DraggableScrollbar.rrect(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Theme.of(context).secondaryHeaderColor,
        padding: const EdgeInsets.only(right: 4),
        labelTextBuilder: (double offset) => Text(
            ((offset ~/ 71.7) + 1).toString(),
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
            itemCount: songs.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == songs.length) {
                return ListTile(title: Container());
              }
              final Song song = songs.elementAt(index);
              return ListTile(
                  title: Text('${song.number}. ${song.name}'),
                  onTap: () {
                    _openSong(context,
                        song.number < 198 ? song.number - 1 : song.number - 3);
                  },
                  trailing: FavoriteIcon(song.number));
            }),
      );
}
