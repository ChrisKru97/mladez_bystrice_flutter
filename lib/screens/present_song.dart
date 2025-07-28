import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/helpers/chords_migration.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';

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

List<String> _chunkTextIntoSlides(String text) {
  final lines = text.split('\n');
  final chunks = <String>[];
  
  // Aim for 3-6 lines per slide, but prioritize fitting text width
  const int minLinesPerSlide = 3;
  const int maxLinesPerSlide = 6;
  const int maxCharsPerLine = 35; // Reasonable character limit per line for good readability
  
  int i = 0;
  while (i < lines.length) {
    final chunk = <String>[];
    int currentLines = 0;
    int totalChars = 0;
    
    // Try to fit as many lines as possible within limits
    while (i < lines.length && currentLines < maxLinesPerSlide) {
      final line = lines[i];
      final lineLength = line.trim().length;
      
      // If this is the first line or we haven't reached minimum lines, add it
      if (currentLines == 0 || currentLines < minLinesPerSlide) {
        chunk.add(line);
        currentLines++;
        totalChars += lineLength;
        i++;
        continue;
      }
      
      // Check if adding this line would make the slide too text-heavy
      final avgCharsPerLine = totalChars / currentLines;
      if (lineLength > maxCharsPerLine && avgCharsPerLine > maxCharsPerLine * 0.7) {
        // Current slide is already text-heavy, start new slide
        break;
      }
      
      // Add the line and continue
      chunk.add(line);
      currentLines++;
      totalChars += lineLength;
      i++;
      
      // If we hit a natural break (empty line), consider starting new slide
      if (line.trim().isEmpty && currentLines >= minLinesPerSlide) {
        break;
      }
    }
    
    if (chunk.isNotEmpty) {
      final chunkText = chunk.join('\n').trim();
      if (chunkText.isNotEmpty) {
        chunks.add(chunkText);
      }
    } else {
      // Safety: if we couldn't process any lines, skip one to avoid infinite loop
      i++;
    }
  }
  
  return chunks.isEmpty ? [''] : chunks;
}

Slides getSlides(dynamic arguments) {
  if (arguments is List<int> && arguments.isNotEmpty) {
    SongsController songsController = Get.find<SongsController>();
    final List<int> slidesWithUnderline = [0];
    final slides = <String>[];
    
    for (final songNumber in arguments) {
      final song = songsController.getSong(songNumber).value;
      final songText = parseAnySongWithChords(song.text);
      final songChunks = _chunkTextIntoSlides(songText.text);
      
      slides.add(song.name); // Add song title
      slides.addAll(songChunks); // Add chunked content
      
      slidesWithUnderline.add(slides.length - songChunks.length); // Mark title position
    }
    
    return Slides(slides, slidesWithUnderline: slidesWithUnderline);
  } else if (arguments is int) {
    final songsController = Get.find<SongsController>();
    final songText =
        parseAnySongWithChords(
          songsController.getSong(arguments).value.text,
        ).text;
    return Slides(_chunkTextIntoSlides(songText));
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
    
    Get.find<AnalyticsService>().logScreenView('present_song');
    final arguments = Get.arguments;
    if (arguments is int) {
      final songsController = Get.find<SongsController>();
      final song = songsController.getSong(arguments).value;
      Get.find<AnalyticsService>().logSongPresentation(song.number.toString(), song.name);
    }

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
