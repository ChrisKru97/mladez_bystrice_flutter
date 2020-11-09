import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  const MyRaisedButton(this.text, this.onPressed, {this.secondary});

  final String text;
  final void Function() onPressed;
  final bool? secondary;

  @override
  Widget build(BuildContext context) => RaisedButton(
        color: (secondary ?? false)
            ? Theme.of(context).secondaryHeaderColor
            : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(text),
      );
}
