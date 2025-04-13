class Config {
  Config(
      {this.showChords = false,
      this.alignCenter = true,
      this.migrated = false,
      this.useNextCollection = false});

  bool showChords;
  bool alignCenter;
  bool migrated;
  bool useNextCollection;

  Map<String, dynamic> toJson() => {
        'showChords': showChords,
        'alignCenter': alignCenter,
        'migrated': migrated,
        'useNextCollection': useNextCollection,
      };

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        showChords: json['showChords'] as bool,
        alignCenter: json['alignCenter'] as bool,
        migrated: json['migrated'] as bool,
        useNextCollection: json['useNextCollection'] as bool? ?? false,
      );
}
