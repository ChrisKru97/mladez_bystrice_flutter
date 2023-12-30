import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/dialogs/bottom_dialog_container.dart';

class ConfirmRemove extends StatelessWidget {
  const ConfirmRemove({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomDialogContainer(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text('Opravdu chcete smazat?', style: TextStyle(fontSize: 18)),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Smazat', style: TextStyle(color: Colors.red))),
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Zrušit'))
        ],
      )
    ]));
  }
}
