class Config {
  Config(
      {this.id = 1,
      this.showChords = false,
      this.alignCenter = true,
      this.lastFirestoreFetch});

  int id;
  bool showChords;
  bool alignCenter;
  DateTime? lastFirestoreFetch;
}
