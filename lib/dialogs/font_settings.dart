import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FontSettings extends StatelessWidget {
  const FontSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    return Container(
      margin: const EdgeInsets.all(20).copyWith(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                // color: Colors.black54,
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 1)
          ]),
      height: 160,
      padding: const EdgeInsets.all(15),
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Akordy',
                            style: TextStyle(fontSize: 22),
                          )),
                      Switch.adaptive(
                        value: configController.config.value.showChords,
                        onChanged: (bool value) =>
                            configController.config.update((val) {
                          if (val == null) return;
                          val.showChords = value;
                        }),
                      ),
                    ],
                  ),
                  ToggleSwitch(
                    icons: const <IconData>[
                      Icons.format_align_left,
                      Icons.format_align_center
                    ],
                    initialLabelIndex:
                        configController.config.value.alignCenter ? 1 : 0,
                    // activeFgColor: Colors.white,
                    labels: const <String>['', ''],
                    onToggle: (int? selected) =>
                        configController.config.update((val) {
                      if (val == null) return;
                      val.alignCenter = 1 == selected;
                    }),
                  )
                ],
              ),
              Slider.adaptive(
                  min: MediaQuery.of(context).size.width * 0.02 >
                          configController.config.value.songFontSize
                      ? configController.config.value.songFontSize
                      : MediaQuery.of(context).size.width * 0.02,
                  max: MediaQuery.of(context).size.width * 0.1 <
                          configController.config.value.songFontSize
                      ? configController.config.value.songFontSize
                      : MediaQuery.of(context).size.width * 0.1,
                  onChanged: (double value) =>
                      configController.config.update((val) {
                        if (val == null) return;
                        val.songFontSize = value;
                      }),
                  value: configController.config.value.songFontSize),
            ],
          )),
    );
  }
}
