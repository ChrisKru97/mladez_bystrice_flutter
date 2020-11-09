import 'dart:async';
import 'bloc.dart';

const List<String> lettersToDeburr = <String>[
  'ě',
  'š',
  'č',
  'ř',
  'ž',
  'ý',
  'á',
  'í',
  'é',
  'ú',
  'ů',
  'ď',
  'ň',
  'ó',
  'ť',
  'ć',
  'ę',
  'ł',
  'ś',
  'ź',
  'ż',
  'ľ',
  'ą'
];

const List<String> lettersDeburred = <String>[
  'e',
  's',
  'c',
  'r',
  'z',
  'y',
  'a',
  'i',
  'e',
  'u',
  'u',
  'd',
  'n',
  'o',
  't',
  'c',
  'e',
  'l',
  's',
  'z',
  'z',
  'l',
  'a'
];

String deburr(String s) {
  final StringBuffer buffer = StringBuffer();
  s.split('').forEach((String c) {
    final int index = lettersToDeburr.indexOf(c);
    buffer.write(index != -1 ? lettersDeburred.elementAt(index) : c);
  });
  return buffer.toString();
}

class SearchBloc implements Bloc {
  final StreamController<String?> _controller = StreamController<String?>();

  Stream<String?> get stream => _controller.stream;

  void search(String s) {
    final String newS = deburr(s).toLowerCase();
    _controller.sink.add(newS);
  }

  void closeSearch() {
    _controller.sink.add(null);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
