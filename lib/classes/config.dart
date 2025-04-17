class Config {
  Config(
      {this.showChords = false,
      this.alignCenter = true,
      this.useNextCollection = false});

  bool showChords;
  bool alignCenter;
  bool useNextCollection;

  Map<String, dynamic> toJson() => {
        'showChords': showChords,
        'alignCenter': alignCenter,
        'useNextCollection': useNextCollection,
      };

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        showChords: json['showChords'] as bool,
        alignCenter: json['alignCenter'] as bool,
        useNextCollection: json['useNextCollection'] as bool? ?? false,
      );
}
