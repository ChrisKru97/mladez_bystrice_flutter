import 'package:objectbox/objectbox.dart';

@Entity()
class Config {
  Config(
      {this.id = 1,
      this.showChords = false,
      this.alignCenter = true,
      this.lastFirestoreFetch,
      this.isDarkMode,
      this.songFontSize = 20});

  @Id(assignable: true)
  int id;
  bool showChords;
  bool alignCenter;
  bool? isDarkMode;
  @Property(type: PropertyType.date)
  DateTime? lastFirestoreFetch;
  double songFontSize;
}
