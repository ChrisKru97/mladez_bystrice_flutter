import 'package:objectbox/objectbox.dart';

@Entity()
class Song {
  @Id(assignable: true)
  int number;
  final String name;
  final String withChords;
  final String withoutChords;
  final String searchValue;
  bool isFavorite;

  Song(
      {required this.number,
      required this.name,
      required this.withChords,
      required this.withoutChords,
      required this.searchValue,
      this.isFavorite = false});
}
