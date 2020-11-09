import 'dart:convert' show jsonEncode;
import 'package:flutter/material.dart' show immutable;

@immutable
class Song {
  const Song({required this.number, required this.name, required this.song});

  final int number;
  final String name;
  final String song;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => name.hashCode ^ song.hashCode ^ number.hashCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'number': number,
        'name': name,
        'song': song,
      };

  @override
  String toString() => jsonEncode(this);
}
