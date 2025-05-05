import 'package:objectbox/objectbox.dart';

@Entity()
class Song {
  @Id(assignable: true)
  int number;
  final String name;
  final String text;
  final String searchValue;
  double fontSize;
  bool isFavorite;
  int transpose;

  Song({required this.number,
    required this.name,
    required this.text,
    required this.searchValue,
    this.transpose = 0,
    this.isFavorite = false,
    this.fontSize = 20});
}
