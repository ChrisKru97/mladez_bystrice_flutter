import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/confirmation_dialog.dart';

class ConfirmRemove extends StatelessWidget {
  const ConfirmRemove({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConfirmationDialog(
      title: 'Opravdu chcete smazat?',
      confirmText: 'Smazat',
    );
  }
}
