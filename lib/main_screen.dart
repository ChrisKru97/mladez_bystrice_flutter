import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
//import 'components/favorite_icon.dart';

//import 'number_select.dart';
import 'classes/song.dart';
//import 'song_display.dart';

class MainScreen extends StatelessWidget {
  final ScrollController _controller = ScrollController();

//  void _openSong(Song song, BuildContext context) {
//    Navigator.of(context).push(MaterialPageRoute<void>(
//        builder: (_) => SongDisplay(
//              song: song,
//            )));
//  }
//
//  void _showDeleteDialog(Song song, BuildContext context) => showDialog(
//      context: context,
//      child: AlertDialog(
//        shape: const RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(5))),
//        title: Text('Odebrat z oblíbených ${song.name}?'),
//        actions: <Widget>[
//          OutlineButton(
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//            child: const Text('Zrušit'),
//          ),
//          RaisedButton(
//              onPressed: () {
//                BlocProvider.of(context).removeFavorite(song.number);
//                Navigator.of(context).pop();
//                Navigator.of(context).pop();
//              },
//              child: const Text('Potvrdit')),
//        ],
//      ));
//
//  void _openSaved(BuildContext context) {
//    Navigator.of(context).push(MaterialPageRoute<void>(
//        builder: (BuildContext context) => Scaffold(
//              appBar: AppBar(
//                title: const Text('Oblíbené'),
//              ),
//              body: ListView(
//                  children: ListTile.divideTiles(
//                      tiles: ConfigBlocProvider.of(context)?.favorites.map(
//                (int number) {
//                  if (number > 197) {
//                    number = number - 2;
//                  }
//                  final Song song = ConfigBlocProvider.of(context)
//                      .songs
//                      .elementAt(number - 1);
//                  return ListTile(
//                    title: Text('${song.number}. ${song.name}'),
//                    onTap: () {
//                      _openSong(song, context);
//                    },
//                    onLongPress: () {
//                      _showDeleteDialog(song, context);
//                    },
//                  );
//                },
//              )).toList()),
//            )));
//  }
//
//  void _chooseNumber(BuildContext context) =>
//      showDialog(child: NumberSelect(), context: context);

  @override
  Widget build(BuildContext context) => StreamBuilder<Config>(
      stream: BlocProvider.of<ConfigBloc>(context).stream,
      initialData: Config(),
      builder: (_, AsyncSnapshot<Config> snapshot) {
        List<Song> songs = BlocProvider.of<SongsBloc>(context)
            .getSongs(showChords: snapshot.data.showChords);
        if (songs == null) {
          return SpinKitWave(color: Theme.of(context).primaryColor);
        }
        return StreamBuilder<String>(
            stream: BlocProvider.of<SearchBloc>(context).stream,
            initialData: null,
            builder: (_, AsyncSnapshot<String> snapshot) {
              if (snapshot.data != null && snapshot.data.isNotEmpty) {
                songs = songs
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
              }
              return Scaffold(
                body: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      StreamBuilder<Set<int>>(
                          stream: BlocProvider.of<SongsBloc>(context).stream,
                          initialData: const <int>{},
                          builder: (_, AsyncSnapshot<Set<int>> snapshot) =>
                              DraggableScrollbar.arrows(
                                padding: const EdgeInsets.only(right: 4),
                                labelTextBuilder: (double offset) => Text(
                                    ((offset ~/ 91) + 1).toString(),
                                    style: TextStyle(color: Colors.white)),
                                controller: _controller,
                                child: ListView.separated(
                                    controller: _controller,
                                    separatorBuilder: (_, __) => Divider(
                                          color: Colors.black12,
                                        ),
                                    itemCount: songs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final Song song = songs.elementAt(index);
//                                    final bool favorited =
//                                        snapshot.data.contains(song.number);
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        title: Text(
                                            '${song.number}. ${song.name}'),
//                                        onTap: () {
//                                          _openSong(song, context);
//                                        },
//                                        trailing: FavoriteIcon(song.number)
                                      );
                                    }),
                              ))
                    ]),
              );
            });
      });
}
