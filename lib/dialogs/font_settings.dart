import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FontSettings extends StatelessWidget {
  const FontSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    final SongsController songsController = Get.find();
    return Container(
      margin: const EdgeInsets.all(20).copyWith(bottom: 30),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[400] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: Get.isDarkMode
              ? null
              : <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 2)
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
                    activeFgColor: Colors.white,
                    inactiveFgColor: Colors.grey[600],
                    inactiveBgColor: Colors.grey[200],
                    icons: const <IconData>[
                      Icons.format_align_left,
                      Icons.format_align_center
                    ],
                    initialLabelIndex:
                        configController.config.value.alignCenter ? 1 : 0,
                    onToggle: (int? selected) =>
                        configController.config.update((val) {
                      if (val == null) return;
                      val.alignCenter = 1 == selected;
                    }),
                  )
                ],
              ),
              Slider.adaptive(
                  min: Get.width * 0.02,
                  max: Get.width * 0.1,
                  onChanged: songsController.updateFontSize,
                  onChangeEnd: songsController.saveFontSize,
                  value: songsController.openSong.value.fontSize),
            ],
          )),
    );
  }
}
