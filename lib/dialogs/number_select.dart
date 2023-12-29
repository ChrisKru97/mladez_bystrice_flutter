import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/dialogs/bottom_sheet.dart';

class NumberSelect extends StatelessWidget {
  NumberSelect({super.key});

  final TextEditingController _fieldController = TextEditingController();
  final SongsController songsController = Get.find();

  void openSong(String number) {
    int parsedNumber;
    parsedNumber = int.parse(number);
    _fieldController.text = '';
    if (!parsedNumber.isNaN && parsedNumber > 0) {
      try {
        final SongsController songsController = Get.find();
        songsController.addToHistory(parsedNumber);
      } on Exception catch (_) {}
      Get.offNamed('/song', arguments: parsedNumber);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastNumber = songsController.songs.last.number;
    return CustomBottomSheet(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      TextField(
        decoration:
            const InputDecoration(counterText: '', border: InputBorder.none),
        controller: _fieldController,
        autofocus: true,
        keyboardType: TextInputType.number,
        onSubmitted: openSong,
        textAlign: TextAlign.center,
        maxLength: 3,
        onChanged: (String data) {
          int number = -1;
          try {
            number = int.parse(data);
          } on Exception catch (_) {
            _fieldController.text = data.substring(0, data.length - 1);
          }
          if (!(number > 0 && number < lastNumber)) {
            _fieldController.text = data.substring(0, data.length - 1);
          }
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextButton(
            child: const Text('Otevřít'),
            onPressed: () => openSong(_fieldController.text),
          ),
          TextButton(
            child: const Text('Zavřít'),
            onPressed: () => Get.back(),
          )
        ],
      )
    ]));
  }
}
