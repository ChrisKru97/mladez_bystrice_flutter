class Config {
  Config({this.showChords = false, this.alignCenter = true});

  bool showChords;
  bool alignCenter;

  Map<String, dynamic> toJson() => {
    'showChords': showChords,
    'alignCenter': alignCenter,
  };

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    showChords: json['showChords'] as bool,
    alignCenter: json['alignCenter'] as bool,
  );
}
