import 'package:objectbox/objectbox.dart';

@Entity()
class Config {
  Config({
    this.id = 1,
    this.showChords = false,
    this.alignCenter = true,
    this.lastFirestoreFetch,
  });

  @Id(assignable: true)
  int id;
  bool showChords;
  bool alignCenter;
  @Property(type: PropertyType.date)
  DateTime? lastFirestoreFetch;
}
