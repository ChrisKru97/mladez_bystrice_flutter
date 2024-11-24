class Song {
  int number;
  final String name;
  final String withChords;
  final String withoutChords;
  final String searchValue;
  double fontSize;
  bool isFavorite;
  int transpose;

  Song({required this.number,
    required this.name,
    required this.withChords,
    required this.withoutChords,
    required this.searchValue,
    this.transpose = 0,
    this.isFavorite = false,
    this.fontSize = 20});
}
