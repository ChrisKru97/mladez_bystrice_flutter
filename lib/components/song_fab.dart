import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/dialogs/font_settings.dart';

class SongFab extends StatelessWidget {
  const SongFab({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      FloatingActionButton(
        mini: true,
        onPressed: () => Get.toNamed('/present-song', arguments: number),
        child: const Icon(Icons.present_to_all),
      ),
      FloatingActionButton(
        mini: true,
        onPressed: () => Get.bottomSheet(const FontSettings()),
        child: const Icon(Icons.format_size),
      )
    ]);
  }
}
