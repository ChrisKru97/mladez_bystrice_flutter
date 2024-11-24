import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/helpers/chords.dart';
import 'package:mladez_zpevnik/helpers/chords_migration.dart';

class TextWithChords extends StatelessWidget {
  const TextWithChords(
      {super.key, required this.text, required this.textStyle});

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final songWithChords = isOldChordsVersion(text)
        ? parseSongWithOldChords(text)
        : parseSongWithChords(text);
    final textOnlyStyle = textStyle.copyWith(height: 2.5);
    return LayoutBuilder(builder: (context, constraints) {
      final textPainter = TextPainter(
        text: TextSpan(text: songWithChords.text, style: textOnlyStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: constraints.maxWidth);

      return Stack(clipBehavior: Clip.none, children: [
        Text(songWithChords.text, style: textOnlyStyle),
        ...songWithChords.chords.map((chord) {
          final offset = textPainter.getOffsetForCaret(
            TextPosition(offset: chord.position),
            Rect.zero,
          );
          return Positioned(
            left: offset.dx,
            top: offset.dy - (textOnlyStyle.fontSize ?? 20) * 0.6,
            child: Text(chord.text,
                style: textStyle.copyWith(
                    color: Colors.blue.shade600, fontWeight: FontWeight.w600)),
          );
        })
      ]);
    });
  }
}
