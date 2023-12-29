import 'package:objectbox/objectbox.dart';

@Entity()
class Config {
  Config(
      {this.id = 1,
      this.showChords = false,
      this.alignCenter = true,
      this.migrated = false,
      this.lastFirestoreFetch});

  @Id(assignable: true)
  int id;
  bool showChords;
  bool alignCenter;
  bool migrated;
  @Property(type: PropertyType.date)
  DateTime? lastFirestoreFetch;
}
