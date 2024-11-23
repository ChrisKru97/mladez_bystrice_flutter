class Chord {
  final int position;
  final String text;

  Chord(this.position, this.text);
}

class SongWithChords {
  final String text;
  final List<Chord> chords;

  SongWithChords(this.text, this.chords);
}
