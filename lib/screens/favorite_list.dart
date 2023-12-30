import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    return Scaffold(
        appBar: AppBar(title: const Text('Oblíbené')),
        body: Obx(() {
          final songs =
              songsController.songs.where((element) => element.isFavorite);
          if (songs.isEmpty) {
            return Center(
                child: Text('Žádné písně',
                    style: TextStyle(
                        fontSize: 30,
                        color: Get.isDarkMode ? Colors.white : Colors.black)));
          }
          return ListView.separated(
              separatorBuilder: (_, __) => const Divider(
                    height: 2,
                  ),
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                final song = songs.elementAt(index);
                removeFavorite() => songsController.toggleFavorite(song.number);
                return DismissibleRemove(
                    onRemove: removeFavorite,
                    dismissibleKey: song.number,
                    child: ListTile(
                      title: Text('${song.number}. ${song.name}',
                          overflow: TextOverflow.ellipsis),
                      onLongPress: removeFavorite,
                      onTap: () {
                        songsController.addToHistory(song.number);
                        Get.toNamed('/song', arguments: song.number);
                      },
                      trailing: IconButton(
                          onPressed: removeFavorite,
                          icon: const Icon(Icons.favorite,
                              color: redColor, size: 30)),
                      contentPadding: const EdgeInsets.only(left: 16, right: 8),
                    ));
              });
        }));
  }
}
