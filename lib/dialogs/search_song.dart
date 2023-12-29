import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

class SearchSong extends StatelessWidget {
  const SearchSong({super.key});

  @override
  Widget build(BuildContext context) {
    final SongsController songsController = Get.find();
    return Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[600] : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: Get.isDarkMode
                ? null
                : <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]),
        height: 80,
        padding: const EdgeInsets.all(15),
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
