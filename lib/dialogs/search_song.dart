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
            // color: Colors.grey[500],
            borderRadius: BorderRadius.circular(15),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  // color: Colors.black54,
                  offset: Offset(0, 0),
                  blurRadius: 10,
                  spreadRadius: 1)
            ]),
        height: 80,
        padding: const EdgeInsets.all(15),
        child: TextField(
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          autocorrect: false,
          textAlign: TextAlign.left,
          onChanged: (String s) => songsController.searchString.value =
              removeDiacritics(s.toLowerCase()),
        ));
  }
}
