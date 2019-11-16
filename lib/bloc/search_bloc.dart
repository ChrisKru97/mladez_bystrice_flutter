import 'dart:async';
import 'bloc.dart';

class SearchBloc implements Bloc {
  final StreamController<String> _controller = StreamController<String>();

  Stream<String> get stream => _controller.stream;

  void search(String s) {
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
