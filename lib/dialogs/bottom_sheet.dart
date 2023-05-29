import 'dart:math';

import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({required this.child, required this.bottom});

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
      child: Container(
          padding: const EdgeInsets.all(10).copyWith(bottom: max(10, bottom)),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 0),
                    spreadRadius: 1,
                    blurRadius: 10)
              ]),
          child: child));
}
