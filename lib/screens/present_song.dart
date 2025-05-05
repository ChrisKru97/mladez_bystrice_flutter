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

class Slides {
  final List<String> slides;
  final List<int>? slidesWithUnderline;

  Slides(this.slides, {this.slidesWithUnderline});
}

Slides getSlides(dynamic arguments) {
  if (arguments is List<int> && arguments.isNotEmpty) {
    SongsController songsController = Get.find<SongsController>();
    final List<int> slidesWithUnderline = [0];
    final slides =
        arguments.expand((songNumber) {
          final songSlides = songsController
              .getSong(songNumber)
              .value
              .text
              .split('\n');
          slidesWithUnderline.add(
            songSlides.length + slidesWithUnderline.last + 1,
          );
          return [
            songsController.getSong(songNumber).value.name,
            ...songsController.getSong(songNumber).value.text.split('\n'),
          ];
        }).toList();
    return Slides(slides, slidesWithUnderline: slidesWithUnderline);
  } else if (arguments is int) {
    final songsController = Get.find<SongsController>();
    return Slides(songsController.getSong(arguments).value.text.split('\n'));
  }
  return Slides([]);
}

class PresentSong extends StatelessWidget {
  PresentSong({super.key});

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final slides = getSlides(Get.arguments);
    final slideTexts = slides.slides;
    final slideUnderlines = slides.slidesWithUnderline;

    var slideDragUpdated = false;

    final shouldRotate = MediaQuery.of(context).size.aspectRatio < 1;
    final fontSize = MediaQuery.of(context).size.longestSide / 20;

    return ObxValue(
      (songIndex) => KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (nextSlideKeys.contains(event.logicalKey)) {
              songIndex.value = (songIndex.value + 1) % slideTexts.length;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              songIndex.value = (songIndex.value - 1) % slideTexts.length;
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              Get.back();
            }
          }
        },
        child: GestureDetector(
          onTap:
              () => songIndex.value = (songIndex.value + 1) % slideTexts.length,
          onDoubleTap: () => Get.back(),
          onVerticalDragEnd: (_) => slideDragUpdated = false,
          onVerticalDragUpdate: (details) {
            if (!slideDragUpdated &&
                details.primaryDelta != null &&
                (details.primaryDelta! > 15 || details.primaryDelta! < -15)) {
              slideDragUpdated = true;
              final slideIncrement = details.primaryDelta! > 15 ? -1 : 1;
              songIndex.value =
                  (songIndex.value + slideIncrement) % slideTexts.length;
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
                      slideTexts[songIndex.value],
                      style: TextStyle(
                        decoration:
                            slideUnderlines?.contains(songIndex.value) == true
                                ? TextDecoration.underline
                                : null,
                        fontSize: fontSize,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      0.obs,
    );
  }
}
