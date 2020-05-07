import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/menu_row.dart';
import 'package:mladez_zpevnik/song_display.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';
import 'components/favorite_icon.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentBottomSheetController bottomSheetController;

  void _openSong(BuildContext context, int number) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => SongDisplay(number)));
  }

  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return StreamBuilder<Config>(
        stream: provider.stream,
        builder: (_, AsyncSnapshot<Config> snapshot) {
          if (snapshot.data == null) {
            provider.refresh();
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          }
          final SongsBloc songsProvider = BlocProvider.of<SongsBloc>(context);
          final List<Song> songs = songsProvider.getSongs();
          if (songs == null) {
            provider.refresh();
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          }
          return StreamBuilder<String>(
              stream: BlocProvider.of<SearchBloc>(context).stream,
              initialData: null,
              builder: (_, AsyncSnapshot<String> snapshot) {
                List<Song> filteredSongs;
                if (snapshot.data != null && snapshot.data.isNotEmpty) {
                  filteredSongs = songs
                      .where((Song song) =>
                          deburr(song.name)
                              .toLowerCase()
                              .contains(snapshot.data) ||
                          deburr(song.song)
                              .toLowerCase()
                              .contains(snapshot.data) ||
                          song.number.toString().contains(snapshot.data))
                      .toList();
                } else {
                  filteredSongs = songs;
                }
                return Scaffold(
                  body: GestureDetector(
                    onTap: () {
                      if (bottomSheetController != null) {
                        bottomSheetController.close();
                        setState(() {
                          bottomSheetController = null;
                        });
                      }
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: 150,
                          floating: true,
                          stretch: true,
                          stretchTriggerOffset: 1,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                              background: SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    "Mládežový zpěvník",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.08),
                                  ),
                                ),
                              ),
                              title: SafeArea(
                                  child: MenuRow(
                                      setBottomSheet: (bottomSheet) {
                                        bottomSheet.closed.then((value) {
                                          setState(() {
                                            bottomSheetController = null;
                                          });
                                        });
                                        setState(() {
                                          bottomSheetController = bottomSheet;
                                        });
                                      },
                                      bottomSheetController:
                                          bottomSheetController))),
                        ),
                        SliverFixedExtentList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            final song = filteredSongs.elementAt(index);
                            return ListTile(
                                title: Text(
                                  '${song.number}. ${song.name}',
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                onTap: () {
                                  if (bottomSheetController != null) {
                                    bottomSheetController.close();
                                    setState(() {
                                      bottomSheetController = null;
                                      _openSong(
                                          context,
                                          song.number < 198
                                              ? song.number - 1
                                              : song.number - 3);
                                    });
                                  } else {
                                    _openSong(
                                        context,
                                        song.number < 198
                                            ? song.number - 1
                                            : song.number - 3);
                                  }
                                },
                                trailing: FavoriteIcon(song.number));
                          }, childCount: filteredSongs.length),
                          itemExtent: 50,
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
