import 'package:flutter/material.dart';
import 'bloc.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  const BlocProvider({this.bloc, this.child});

  final Widget child;
  final T bloc;

  static T of<T extends Bloc>(BuildContext context) {
    final BlocProvider<T> provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
  }

  @override
  State createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
