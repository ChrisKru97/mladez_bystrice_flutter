import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/components/dismissible_remove.dart';
import 'package:mladez_zpevnik/dialogs/create_playlist.dart';

class Playlists extends StatelessWidget {
  const Playlists({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController playlistController = Get.find();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Playlisty'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Get.bottomSheet(CreatePlaylist()),
            ),
          ],
        ),
        body: Obx(() => playlistController.playlists.isEmpty
            ? Center(
                child: GestureDetector(
                    onTap: () => Get.bottomSheet(CreatePlaylist()),
                    child:
                        const Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add, size: 50),
                      Text('Přidat'),
                    ])))
            : ListView.separated(
                separatorBuilder: (_, __) => const Divider(
                      height: 2,
                    ),
                itemCount: playlistController.playlists.length,
                itemBuilder: (BuildContext context, int index) {
                  final playlist =
                      playlistController.playlists.elementAt(index);
                  return DismissibleRemove(
                      dismissibleKey: playlist.name,
                      onRemove: () =>
                          playlistController.removePlaylist(playlist.name),
                      confirmDismiss: true,
                      child: ListTile(
                        title: Text(playlist.name,
                            overflow: TextOverflow.ellipsis),
                        trailing: Text('${playlist.songsOrder?.length ?? 0}'),
                        onTap: () =>
                            Get.toNamed('/playlist', arguments: playlist.name),
                      ));
                })));
  }
}
