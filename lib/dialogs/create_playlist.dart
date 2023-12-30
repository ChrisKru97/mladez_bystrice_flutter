import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/dialogs/bottom_dialog_container.dart';

class CreatePlaylist extends StatelessWidget {
  CreatePlaylist({super.key});

  final textEditingController = TextEditingController();

  void onSubmit() {
    if (textEditingController.text.isEmpty) return;
    final PlaylistController playlistController = Get.find();
    playlistController.addPlaylist(textEditingController.text);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return BottomDialogContainer(
        child: Row(children: [
      Expanded(
          child: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: 'Název playlistu'),
        autofocus: true,
        autocorrect: false,
        textAlign: TextAlign.left,
        onSubmitted: (_) => onSubmit(),
      )),
      TextButton(onPressed: onSubmit, child: const Text('Vytvořit'))
    ]));
  }
}
