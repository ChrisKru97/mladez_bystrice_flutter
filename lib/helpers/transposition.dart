const chordProgression1 = [
  'C',
  'Cis',
  'D',
  'Dis',
  'E',
  'F',
  'Fis',
  'G',
  'Gis',
  'A',
  'Ais',
  'B',
];

const chordProgression2 = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];

const chordProgression3 = [
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
];

String transposeChord(String chord, int semitones) {
  if (semitones == 0) return chord;
  final chordProgression = chordProgression1;
  final index = chordProgression.indexOf(chord);
  if (index == -1) {
    return '?$chord';
  }
  final newIndex = (index + semitones) % chordProgression.length;
  return chordProgression[newIndex];
}
