import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomDialogContainer extends StatelessWidget {
  const BottomDialogContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[400] : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: Get.isDarkMode
                ? null
                : <BoxShadow>[
                    const BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]),
        padding: const EdgeInsets.all(15),
        child: child);
  }
}
