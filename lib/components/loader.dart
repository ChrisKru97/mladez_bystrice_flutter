import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SpinKitWave(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Theme.of(context).primaryColor);
}
