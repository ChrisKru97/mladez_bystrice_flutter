import 'dart:ui';
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'bloc/search_controller.dart';
import 'classes/song.dart';
import 'components/menu_row.dart';
import 'components/song_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentBottomSheetController<dynamic>? bottomSheetController;

  void setBottomSheet(
          PersistentBottomSheetController<dynamic>? newBottomSheetController) =>
      setState(() {
        bottomSheetController = newBottomSheetController;
      });

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    final SearchController searchController = Get.find();
    final List<Song> songs = songsController.songs;
    if (songs.isEmpty) {
      return Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator.adaptive()));
    }
    List<Song> filteredSongs;
    if (searchController.search.isNotEmpty) {
      filteredSongs = songs
          .where((Song song) =>
              deburr(song.name)
                  .toLowerCase()
                  .contains(searchController.search) ||
              deburr(song.withoutChords)
                  .toLowerCase()
                  .contains(searchController.search) ||
              song.number.toString().contains(searchController.search))
          .toList();
    } else {
      filteredSongs = songs;
    }
    final double titleSize = MediaQuery.of(context).size.width * 0.13;
    return GestureDetector(
        onTap: () {
          if (bottomSheetController != null) {
            bottomSheetController?.close();
            searchController.search.value = '';
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
  }
}
