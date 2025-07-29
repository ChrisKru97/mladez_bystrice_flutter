import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const List<LogicalKeyboardKey> nextSlideKeys = [
  LogicalKeyboardKey.enter,
  LogicalKeyboardKey.space,
  LogicalKeyboardKey.arrowRight,
];

class PresentationScreenBase extends StatelessWidget {
  const PresentationScreenBase({
    super.key,
    required this.child,
    required this.totalSlides,
    required this.currentSlideIndex,
    this.onNextSlide,
    this.onPreviousSlide,
    this.onExit,
    this.onTap,
    this.onDoubleTap,
    this.onVerticalDragUpdate,
  });

  final Widget child;
  final int totalSlides;
  final RxInt currentSlideIndex;
  final VoidCallback? onNextSlide;
  final VoidCallback? onPreviousSlide;
  final VoidCallback? onExit;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  void _handleNextSlide() {
    if (onNextSlide != null) {
      onNextSlide!();
    } else {
      currentSlideIndex.value = (currentSlideIndex.value + 1) % totalSlides;
    }
  }

  void _handlePreviousSlide() {
    if (onPreviousSlide != null) {
      onPreviousSlide!();
    } else {
      currentSlideIndex.value = (currentSlideIndex.value - 1) % totalSlides;
    }
  }

  void _handleExit() {
    if (onExit != null) {
      onExit!();
    } else {
      Get.back();
    }
  }

  void _handleTap() {
    if (onTap != null) {
      onTap!();
    } else {
      _handleNextSlide();
    }
  }

  void _handleDoubleTap() {
    if (onDoubleTap != null) {
      onDoubleTap!();
    } else {
      _handleExit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    var slideDragUpdated = false;

    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (nextSlideKeys.contains(event.logicalKey)) {
            _handleNextSlide();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _handlePreviousSlide();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            _handleExit();
          }
        }
      },
      child: GestureDetector(
        onTap: _handleTap,
        onDoubleTap: _handleDoubleTap,
        onVerticalDragEnd: (_) => slideDragUpdated = false,
        onVerticalDragUpdate: (details) {
          if (onVerticalDragUpdate != null) {
            onVerticalDragUpdate!(details);
          } else if (!slideDragUpdated &&
              details.primaryDelta != null &&
              (details.primaryDelta! > 15 || details.primaryDelta! < -15)) {
            slideDragUpdated = true;
            final slideIncrement = details.primaryDelta! > 15 ? -1 : 1;
            if (slideIncrement == 1) {
              _handleNextSlide();
            } else {
              _handlePreviousSlide();
            }
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: child,
          ),
        ),
      ),
    );
  }
}