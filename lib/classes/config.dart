class Config {
  Config(
      {this.showChords = false,
      this.alignCenter = true,
      this.migrated = false,
      this.lastFirestoreFetch});

  bool showChords;
  bool alignCenter;
  bool migrated;
  DateTime? lastFirestoreFetch;

  Map<String, dynamic> toJson() => {
        'showChords': showChords,
        'alignCenter': alignCenter,
        'migrated': migrated,
        'lastFirestoreFetch': lastFirestoreFetch?.toIso8601String(),
      };

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        showChords: json['showChords'] as bool,
        alignCenter: json['alignCenter'] as bool,
        migrated: json['migrated'] as bool,
        lastFirestoreFetch: json['lastFirestoreFetch'] == null
            ? null
            : DateTime.parse(json['lastFirestoreFetch'] as String),
      );
}
