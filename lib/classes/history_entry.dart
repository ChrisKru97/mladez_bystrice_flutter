import 'package:objectbox/objectbox.dart';

@Entity()
class HistoryEntry {
  HistoryEntry({this.id = 0, required this.openedAt, required this.songNumber});

  @Id()
  int id;
  int songNumber;
  @Property(type: PropertyType.date)
  DateTime openedAt;
}
