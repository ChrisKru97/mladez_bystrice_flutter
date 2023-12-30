import 'package:objectbox/objectbox.dart';

@Entity()
class Playlist {
  Playlist({this.id = 0, required this.name, this.songsOrder});

  @Id()
  int id;
  String name;
  List<int>? songsOrder;
}
