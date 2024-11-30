import 'package:mladez_zpevnik/helpers/chords_migration.dart';

const chordProgressionReverse = [
  'H',
  'Ais',
  'A',
  'Gis',
  'G',
  'Fis',
  'F',
  'E',
  'Dis',
  'D',
  'Cis',
  'C',
];

String transposeChord(String chord, int semitones) {
  final isMinor = chord.contains('m');
  final parsedChord = chord.replaceFirst('#', 'is');
  final secondChordMatch = chordPattern.firstMatch(parsedChord);
  final secondChord = secondChordMatch?.group(1)?.replaceFirst(r'/', '') ??
      secondChordMatch?.group(2)?.replaceFirst('(', '').replaceFirst(')', '');
  final divider = chord.contains('/')
      ? '/'
      : chord.contains('(')
          ? '('
          : '';
  if (semitones == 0) return parsedChord;
  final index =
      chordProgressionReverse.indexWhere((el) => parsedChord.startsWith(el));
  if (index == -1) {
    return '?$parsedChord';
  }
  final newIndex = (index - semitones) % chordProgressionReverse.length;
  return '${chordProgressionReverse[newIndex]}${isMinor ? 'm' : ''}$divider${secondChord != null ? transposeChord(secondChord, semitones) : ''}${divider == '(' ? ')' : ''}';
}
