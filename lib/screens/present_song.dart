import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

const nextSlideKeys = [
  LogicalKeyboardKey.enter,
  LogicalKeyboardKey.space,
  LogicalKeyboardKey.arrowRight,
];

class PresentSong extends StatelessWidget {
  PresentSong({super.key});

  final FocusNode _focusNode = FocusNode();
  var slideDragUpdated = false;

  @override
  Widget build(BuildContext context) {
    final number = Get.arguments as int;
    SongsController songsController = Get.find();
    final song = songsController.getSong(number);

    final songParts = song.value.withoutChords.split('\n');

    final shouldRotate = MediaQuery.of(context).size.aspectRatio < 1;
    final fontSize = MediaQuery.of(context).size.longestSide / 20;

    return ObxValue(
        (songIndex) => KeyboardListener(
              focusNode: _focusNode,
              autofocus: true,
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  if (nextSlideKeys.contains(event.logicalKey)) {
                    songIndex.value = (songIndex.value + 1) % songParts.length;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                    songIndex.value = (songIndex.value - 1) % songParts.length;
                  } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                    Get.back();
                  }
                }
              },
              child: GestureDetector(
                onTap: () =>
                    songIndex.value = (songIndex.value + 1) % songParts.length,
                onDoubleTap: () => Get.back(),
                onHorizontalDragEnd: (_) => slideDragUpdated = false,
                onHorizontalDragUpdate: (details) {
                  if (!slideDragUpdated &&
                      details.primaryDelta != null &&
                      (details.primaryDelta! > 15 ||
                          details.primaryDelta! < -15)) {
                    slideDragUpdated = true;
                    final slideIncrement = details.primaryDelta! > 15 ? 1 : -1;
                    songIndex.value =
                        (songIndex.value + slideIncrement) % songParts.length;
                  }
                },
                child: Scaffold(
                  body: SafeArea(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: RotatedBox(
                            quarterTurns: shouldRotate ? 1 : 0,
                            child: AutoSizeText(
                              songParts[songIndex.value],
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ),
        0.obs);
  }
}
