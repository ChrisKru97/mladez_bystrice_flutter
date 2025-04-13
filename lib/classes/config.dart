import 'package:objectbox/objectbox.dart';

@Entity()
class Config {
  Config(
      {this.id = 1,
      this.showChords = false,
      this.alignCenter = true,
      this.lastFirestoreFetch,
      this.useNextCollection = false});

  @Id(assignable: true)
  int id;
  bool showChords;
  bool alignCenter;
  bool useNextCollection;
  @Property(type: PropertyType.date)
  DateTime? lastFirestoreFetch;
}
