import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/menu_row.dart';
import 'package:mladez_zpevnik/components/song_list.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentBottomSheetController bottomSheetController;

  void setBottomSheet(
          PersistentBottomSheetController newBottomSheetController) =>
      setState(() {
        bottomSheetController = newBottomSheetController;
      });

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
                return GestureDetector(
                    onTap: () {
                      if (bottomSheetController != null) {
                        bottomSheetController.close();
                        BlocProvider.of<SearchBloc>(context).search('');
                      }
                    },
                    child: Scaffold(
                      appBar: AppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          flexibleSpace: SafeArea(
                            child: Center(
                              child: Text(
                                "Mládežový zpěvník",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.08),
                              ),
                            ),
                          )),
                      body: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SongList(
                              trimmed: true,
                              songs: filteredSongs,
                              bottomSheetController: bottomSheetController,
                              setBottomSheet: setBottomSheet),
                          ClipRect(
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                child: MenuRow(setBottomSheet: setBottomSheet)),
                          ),
                        ],
                      ),
                    ));
              });
        });
  }
}
