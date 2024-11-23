import 'package:mladez_zpevnik/classes/song_with_chords.dart';

final chordsPattern = RegExp(r'\[(\w+\d?\+?)\]', caseSensitive: false);

SongWithChords parseSongWithChords(String songWithChords) {
  final patternMatches =
      chordsPattern.allMatches(songWithChords).where((e) => e.groupCount > 0);
  String textOnly = songWithChords.substring(0, patternMatches.first.start);
  int offset = 0;
  List<Chord> chords = patternMatches.indexed.map((e) {
    final patternMatch = e.$2;
    final nextPatternMatch = patternMatches.elementAtOrNull(e.$1 + 1);
    textOnly +=
        songWithChords.substring(patternMatch.end, nextPatternMatch?.start);
    final chord = Chord(patternMatch.start - offset, patternMatch.group(1)!);
    offset += patternMatch.group(0)!.length;
    return chord;
  }).toList();
  return SongWithChords(textOnly, chords);
}
