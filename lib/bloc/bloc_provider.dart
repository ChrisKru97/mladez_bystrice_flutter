import 'package:flutter/material.dart';
import 'bloc.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  const BlocProvider({@required this.bloc, @required this.child, Key key})
      : super(key: key);

  final Widget child;
  final T bloc;

  static T of<T extends Bloc>(BuildContext context) {
    final Type type = _providerType<BlocProvider<T>>();
    final BlocProvider<T> provider =
        context.ancestorWidgetOfExactType(type) as BlocProvider<T>;
    return provider.bloc;
  }

  static Type _providerType<T>() => T;

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
