import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/dialogs/confirm_remove.dart';

class DismissibleRemove extends StatelessWidget {
  const DismissibleRemove(
      {super.key,
      required this.child,
      required this.onRemove,
      required this.dismissibleKey,
      this.confirmDismiss = false});

  final Widget child;
  final Function() onRemove;
  final dynamic dismissibleKey;
  final bool confirmDismiss;

  Future<bool?> handleConfirmDismiss(_) =>
      Get.bottomSheet(const ConfirmRemove());

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        confirmDismiss: confirmDismiss ? handleConfirmDismiss : null,
        onDismissed: (_) => onRemove(),
        background: Container(
            padding: const EdgeInsets.only(left: 12),
            color: Colors.red,
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete, color: Colors.white))),
        secondaryBackground: Container(
            padding: const EdgeInsets.only(right: 12),
            color: Colors.red,
            child: const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white))),
        key: Key(dismissibleKey.toString()),
        child: child);
  }
}
