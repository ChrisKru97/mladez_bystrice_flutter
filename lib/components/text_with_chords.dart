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
    final songWithChoords = isOldChordsVersion(text)
        ? parseSongWithOldChords(text)
        : parseSongWithChords(text);
    return RichText(
        text: TextSpan(
      style: textStyle.copyWith(height: 2.5),
      children: songWithChoords.chords.indexed.map((item) {
        final chord = item.$2;
        final nextChord = songWithChoords.chords.elementAtOrNull(item.$1 + 1);
        final chordText =
            songWithChoords.text.substring(chord.position, nextChord?.position);
        return TextSpan(
          children: [
            WidgetSpan(
                child: SizedBox(
              width: 0,
              child: FractionalTranslation(
                translation: Offset(0, -0.7),
                child: Text(chord.text,
                    maxLines: 1,
                    style: textStyle.copyWith(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold)),
              ),
            )),
            TextSpan(text: chordText),
          ],
        );
      }).toList(),
    ));
  }
}
