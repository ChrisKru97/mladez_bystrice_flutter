import 'package:mladez_zpevnik/classes/song_with_chords.dart';
import 'package:mladez_zpevnik/helpers/chords.dart';

final chordPattern = RegExp(
    r'[A-Z][a-z]{0,3}7?\+?(\/[A-Z][a-z]{0,3}7?\+?)?(\([A-Z][a-z]{0,3}7?\+?(\/[A-Z][a-z]{0,3}7?\+?)?\))?');

bool isLineWithChords(String line) {
  final chords = chordPattern.allMatches(line).map((e) => e.group(0));
  return chords.fold<int>(chords.length - 1,
          (previousValue, element) => previousValue + element!.length) >=
      line.length;
}

String mergeLines(String lineWithChords, String lineWithoutChords) {
  final chords =
      chordPattern.allMatches(lineWithChords).map((e) => e.group(0)!);
  final chordSpace = (lineWithoutChords.length / chords.length).floor();
  return chords.indexed.map((item) {
    final isLast = item.$1 == chords.length - 1;
    return '[${item.$2}]${lineWithoutChords.substring(item.$1 * chordSpace, isLast ? null : (item.$1 + 1) * chordSpace)}';
  }).join('');
}

SongWithChords parseSongWithOldChords(String songWithOldChords) {
  final byLines = songWithOldChords.split('\n');
  String? lastLineWithChords;
  final List<String> parsedLines = [];
  for (final item in byLines) {
    final withSpacesTrimmed = item.replaceAll(RegExp(r'\s+'), ' ').trim();
    final isWithChords = isLineWithChords(withSpacesTrimmed);
    if (isWithChords) {
      lastLineWithChords = withSpacesTrimmed;
    } else if (lastLineWithChords != null) {
      parsedLines.add(mergeLines(lastLineWithChords, withSpacesTrimmed));
      lastLineWithChords = null;
    } else {
      parsedLines.add(withSpacesTrimmed);
    }
  }
  return parseSongWithChords(parsedLines.join('\n'));
}

bool isOldChordsVersion(String text) => !chordsPattern.hasMatch(text);

SongWithChords parseAnySongWithChords(String text) => isOldChordsVersion(text)
    ? parseSongWithOldChords(text)
    : parseSongWithChords(text);
