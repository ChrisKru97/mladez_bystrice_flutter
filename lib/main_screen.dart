import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';
import 'components/menu_row.dart';
import 'components/song_list.dart';
import 'dialogs/starting_info.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool checkedForStartingDialog = false;
  PersistentBottomSheetController<dynamic>? bottomSheetController;

  void setBottomSheet(
          PersistentBottomSheetController<dynamic>? newBottomSheetController) =>
      setState(() {
        bottomSheetController = newBottomSheetController;
      });

  Future<void> checkStartingDialog(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool dontShowStartingInfo =
        prefs.getBool(dontShowStartingInfoKey) ?? false;
    if (!dontShowStartingInfo) {
      await showDialog(
          context: context, builder: (BuildContext context) => StartingInfo());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!checkedForStartingDialog) {
      checkedForStartingDialog = true;
      checkStartingDialog(context);
    }
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return StreamBuilder<Config>(
        stream: provider.stream,
        builder: (_, AsyncSnapshot<Config> snapshot) {
          if (snapshot.data == null) {
            provider.refresh();
            return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()));
          }
          final SongsBloc songsProvider = BlocProvider.of<SongsBloc>(context);
          final List<Song> songs = songsProvider.getSongs();
          if (songs.isEmpty) {
            provider.refresh();
            return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()));
          }
          return StreamBuilder<String?>(
              stream: BlocProvider.of<SearchBloc>(context).stream,
              builder: (_, AsyncSnapshot<String?> snapshot) {
                List<Song> filteredSongs;
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  filteredSongs = songs
                      .where((Song song) =>
                          deburr(song.name)
                              .toLowerCase()
                              .contains(snapshot.data!) ||
                          deburr(song.withoutChords)
                              .toLowerCase()
                              .contains(snapshot.data!) ||
                          song.number.toString().contains(snapshot.data!))
                      .toList();
                } else {
                  filteredSongs = songs;
                }
                final double titleSize =
                    MediaQuery.of(context).size.width * 0.13;
                return GestureDetector(
                    onTap: () {
                      if (bottomSheetController != null) {
                        bottomSheetController?.close();
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
                                'Mládežový zpěvník',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleSize < 38 ? titleSize : 38),
                              ),
                            ),
                          )),
                      body: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          SongList(
                              trimmed: true,
                              songs: filteredSongs,
                              bottomSheetController: bottomSheetController,
                              setBottomSheet: setBottomSheet),
                          ClipRect(
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                child: MenuRow(
                                    setBottomSheet: setBottomSheet,
                                    lastNumber: songs.last.number + 1)),
                          ),
                        ],
                      ),
                    ));
              });
        });
  }
}
