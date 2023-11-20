import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bloc/songs_controller.dart';
import '../components/song_list.dart';

class FavouriteList extends StatelessWidget {
  const FavouriteList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(),
            flexibleSpace: const SafeArea(
                child: Center(
                    child: Text(
              'Oblíbené',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )))),
        body: Obx(() => SongList(
            songs: songsController.songs
                .where((song) => song.isFavorite)
                .toList())));
  }
}
