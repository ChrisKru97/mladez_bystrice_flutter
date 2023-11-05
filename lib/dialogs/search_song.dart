import 'dart:math';
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../bloc/search_controller.dart';

class SearchSong extends StatelessWidget {
  const SearchSong({super.key, required this.bottom});

  final double bottom;

  @override
  Widget build(BuildContext context) {
    final SearchController searchController = Get.find();
    return Container(
      margin: const EdgeInsets.all(15).copyWith(bottom: max(15, bottom)),
      decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
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
          onChanged: (value) {
            searchController.search.value = value;
          }),
    );
  }
}
