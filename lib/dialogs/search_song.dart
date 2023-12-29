import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/dialogs/bottom_dialog_container.dart';

class SearchSong extends StatelessWidget {
  const SearchSong({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    return BottomDialogContainer(
        child: TextField(
      decoration: const InputDecoration(border: InputBorder.none),
      autofocus: true,
      autocorrect: false,
      textAlign: TextAlign.left,
      onSubmitted: (_) => Get.back(),
      onChanged: (String s) => songsController.searchString.value =
          removeDiacritics(s.toLowerCase()),
    ));
  }
}
