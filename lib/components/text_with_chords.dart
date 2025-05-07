import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/classes/song_with_chords.dart';
import 'package:mladez_zpevnik/helpers/transposition.dart';

class TextWithChords extends StatelessWidget {
  const TextWithChords({
    super.key,
    required this.songWithChords,
    required this.textStyle,
    required this.textAlign,
    required this.transposition,
  });

  final SongWithChords songWithChords;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final int transposition;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    final textOnlyStyle = textStyle.copyWith(height: 2.5);
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: songWithChords.text, style: textOnlyStyle),
          textDirection: TextDirection.ltr,
          textAlign: textAlign,
          textScaler: textScaler,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              songWithChords.text,
              style: textOnlyStyle,
              textAlign: textAlign,
            ),
            ...songWithChords.chords.map((chord) {
              final offset = textPainter.getOffsetForCaret(
                TextPosition(offset: chord.position),
                Rect.zero,
              );
              return Positioned(
                left: offset.dx,
                top:
                    offset.dy -
                    textScaler.scale((textOnlyStyle.fontSize ?? 20)) * 0.4,
                child: Text(
                  transposeChord(chord.text, transposition),
                  style: textStyle.copyWith(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: (textStyle.fontSize ?? 20) * 0.9,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
