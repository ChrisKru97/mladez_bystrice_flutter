import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/favorite_icon.dart';

class SongsWithSearch extends StatelessWidget {
  const SongsWithSearch({super.key});

  @override
  Widget build(BuildContext context) => Obx(() {
        final SongsController songsController = Get.find();
        final ConfigController configController = Get.find();
        final songs = songsController.filteredSongs;
        if (songs.isEmpty) {
          if (songsController.searchString.value.isNotEmpty) {
            return Center(
                child: Text('Žádné výsledky',
                    style: TextStyle(
                        fontSize: 30,
                        color: Get.isDarkMode ? Colors.white : Colors.black)));
          }
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator.adaptive(
            onRefresh: () => songsController.loadSongs(force: true),
            child: Scrollbar(
                child: ListView.separated(
                    separatorBuilder: (_, __) => const Divider(
                          height: 2,
                        ),
                    itemCount: songs.length,
                    padding: EdgeInsets.only(
                        bottom: configController.bottomBarHeight.value),
                    itemBuilder: (BuildContext context, int index) {
                      final song = songs.elementAt(index);
                      return ListTile(
                        onLongPress: () =>
                            songsController.toggleFavorite(song.number),
                        title: Text('${song.number}. ${song.name}',
                            overflow: TextOverflow.ellipsis),
                        onTap: () {
                          songsController.addToHistory(song.number);
                          Get.toNamed('/song', arguments: song.number);
                        },
                        trailing:
                            FavoriteIcon(song.isFavorite, number: song.number),
                        contentPadding:
                            const EdgeInsets.only(left: 16, right: 8),
                      );
                    })));
      });
}
