import 'package:mladez_zpevnik/classes/song.dart';

class SongWithHistory {
  DateTime openedAt;
  Song? song;

  SongWithHistory({required this.openedAt, required this.song});
}
