import 'dart:async';
import 'bloc.dart';

String deburr(String s) => s
    .replaceAll(RegExp(r"ě", caseSensitive: false), "e")
    .replaceAll(RegExp(r"š", caseSensitive: false), "s")
    .replaceAll(RegExp(r"č", caseSensitive: false), "c")
    .replaceAll(RegExp(r"ř", caseSensitive: false), "r")
    .replaceAll(RegExp(r"ž", caseSensitive: false), "z")
    .replaceAll(RegExp(r"ý", caseSensitive: false), "y")
    .replaceAll(RegExp(r"á", caseSensitive: false), "a")
    .replaceAll(RegExp(r"í", caseSensitive: false), "i")
    .replaceAll(RegExp(r"é", caseSensitive: false), "e")
    .replaceAll(RegExp(r"ú", caseSensitive: false), "u")
    .replaceAll(RegExp(r"ů", caseSensitive: false), "u")
    .replaceAll(RegExp(r"ď", caseSensitive: false), "d")
    .replaceAll(RegExp(r"ň", caseSensitive: false), "n")
    .replaceAll(RegExp(r"ó", caseSensitive: false), "o")
    .replaceAll(RegExp(r"ť", caseSensitive: false), "t")
    .replaceAll(RegExp(r"ć", caseSensitive: false), "c")
    .replaceAll(RegExp(r"ę", caseSensitive: false), "e")
    .replaceAll(RegExp(r"ł", caseSensitive: false), "l")
    .replaceAll(RegExp(r"ś", caseSensitive: false), "s")
    .replaceAll(RegExp(r"ź", caseSensitive: false), "z")
    .replaceAll(RegExp(r"ż", caseSensitive: false), "z")
    .replaceAll(RegExp(r"ą", caseSensitive: false), "a");

class SearchBloc implements Bloc {
  final StreamController<String> _controller = StreamController<String>();

  Stream<String> get stream => _controller.stream;

  void search(String s) {
    s = deburr(s).toLowerCase();
    _controller.sink.add(s);
  }

  void closeSearch() {
    _controller.sink.add(null);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
