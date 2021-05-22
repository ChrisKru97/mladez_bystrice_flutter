import 'dart:convert' show jsonEncode;
import 'package:flutter/material.dart' show immutable;

@immutable
class Song {
  const Song(
      {required this.number,
      required this.name,
      required this.withoutChords,
      required this.withChords});

  final int number;
  final String name;
  final String withChords;
  final String withoutChords;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode =>
      name.hashCode ^
      withChords.hashCode & withoutChords.hashCode ^
      number.hashCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'number': number,
        'name': name,
        'withChords': withChords,
        'withoutChords': withoutChords,
      };

  @override
  String toString() => jsonEncode(this);
}
