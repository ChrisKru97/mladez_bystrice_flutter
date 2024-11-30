import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/dialogs/bottom_dialog_container.dart';
import 'package:mladez_zpevnik/helpers/chords_migration.dart';
import 'package:mladez_zpevnik/helpers/transposition.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FontSettings extends StatelessWidget {
  const FontSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    final SongsController songsController = Get.find();
    return BottomDialogContainer(
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
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
                  min: min(Get.width * 0.02, 20),
                  max: max(Get.width * 0.1, 20),
                  onChanged: songsController.updateFontSize,
                  onChangeEnd: songsController.saveFontSize,
                  value: songsController.openSong.value.fontSize),
              if (configController.config.value.showChords)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transpozice: ${songsController.openSong.value.transpose}',
                      style: TextStyle(fontSize: 22),
                    ),
                    if (songsController.openSong.value.transpose != 0)
                      Builder(builder: (context) {
                        final firstChord = parseAnySongWithChords(
                                songsController.openSong.value.withChords)
                            .chords
                            .firstOrNull
                            ?.text;
                        if (firstChord == null) return const Center();
                        return Text(
                          '$firstChord -> ${transposeChord(firstChord, songsController.openSong.value.transpose)}',
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue[700]),
                        );
                      }),
                    Row(children: [
                      TextButton(
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                        onPressed: songsController.updateTranspose(-1),
                        child: Text('-1',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                        onPressed: songsController.updateTranspose(1),
                        child: Text('+1',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ])
                  ],
                )
            ],
          )),
    );
  }
}
