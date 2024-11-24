import 'dart:convert';

class Playlist {
  Playlist({required this.name, this.songsOrder});

  String name;
  List<int>? songsOrder;

  Map<String, dynamic> toJson() => {
        'name': name,
        'songsOrder': jsonEncode(songsOrder),
      };

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        name: json['name'] as String,
        songsOrder: jsonDecode(json['songsOrder'] as String).cast<int>(),
      );
}
