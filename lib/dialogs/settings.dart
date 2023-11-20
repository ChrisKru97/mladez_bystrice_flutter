import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'bottom_sheet.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigController configController = Get.find();
    return CustomBottomSheet(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Pozadí aplikace',
                style: TextStyle(fontSize: 22, color: Colors.black))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('Světlé', style: TextStyle(color: Colors.black)),
            Obx(() => Switch.adaptive(
                value:
                    configController.config.value.isDarkMode ?? Get.isDarkMode,
                onChanged: (bool value) {
                  Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  configController.config.update((val) {
                    if (val == null) return;
                    val.isDarkMode = value;
                  });
                })),
            const Text('Tmavé', style: TextStyle(color: Colors.black)),
          ],
        ),
      ]),
    );
  }
}
