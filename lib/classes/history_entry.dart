class HistoryEntry {
  HistoryEntry({this.id = 0, required this.openedAt, required this.songNumber});

  int id;
  int songNumber;
  DateTime openedAt;
}
