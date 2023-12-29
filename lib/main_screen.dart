import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/components/songs_with_search.dart';
import 'components/menu_row.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SizedBox(
              width: Get.width * 0.65,
              child: const FittedBox(
                  child: Text(
                'Mládežový zpěvník',
              )))),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          const SongsWithSearch(),
          ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: const MenuRow()),
          ),
        ],
      ),
    );
  }
}
