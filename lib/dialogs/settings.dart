import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'bottom_sheet.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, required this.bottom});

  final double bottom;

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    final Color primary = Theme.of(context).brightness == Brightness.dark
        ? Colors.black54
        : configController.config.value.primary;
    return CustomBottomSheet(
      bottom: bottom,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Pozadí aplikace',
                style: TextStyle(fontSize: 22, color: Colors.black))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('Světlé', style: TextStyle(color: Colors.black)),
            Switch.adaptive(
              value: configController.config.value.darkMode,
              activeTrackColor: primary.withOpacity(0.6),
              activeColor: primary,
              onChanged: (bool value) {
                configController.config.value.darkMode = value;
              },
            ),
            const Text('Tmavé', style: TextStyle(color: Colors.black)),
          ],
        ),
      ]),
    );
  }
}
