import 'package:flutter/material.dart';

class TripleTapDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onTripleTap;
  final Duration tapDelay;

  const TripleTapDetector({
    Key? key,
    required this.child,
    required this.onTripleTap,
    this.tapDelay = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<TripleTapDetector> createState() => _TripleTapDetectorState();
}

class _TripleTapDetectorState extends State<TripleTapDetector> {
  int tapCount = 0;
  DateTime lastTapTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        if (now.difference(lastTapTime) < widget.tapDelay) {
          tapCount++;
          if (tapCount == 3) {
            widget.onTripleTap();
            tapCount = 0;
          }
        } else {
          tapCount = 1;
        }
        lastTapTime = now;
      },
      child: widget.child,
    );
  }
}
