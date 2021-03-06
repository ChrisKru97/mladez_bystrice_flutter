import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/songs_bloc.dart';
import '../components/my_raised_button.dart';
import '../dialogs/bottom_sheet.dart';
import '../song_display.dart';

class NumberSelect extends StatelessWidget {
  NumberSelect(this.lastNumber);

  final int lastNumber;
  final TextEditingController _fieldController = TextEditingController();

  void openSong(BuildContext context, String number) {
    int parsedNumber;
    parsedNumber = int.parse(number);
    _fieldController.text = '';
    if (!parsedNumber.isNaN &&
        (parsedNumber > 0 && parsedNumber < 198 ||
            parsedNumber > 199 && parsedNumber < lastNumber)) {
      final int finalNumber = parsedNumber - (parsedNumber < 198 ? 1 : 3);
      try {
        BlocProvider.of<SongsBloc>(context)!.addToHistory(finalNumber);
      } on Exception catch (_) {}
      Navigator.of(context)!.push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => SongDisplay(finalNumber),
      ));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => CustomBottomSheet(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        TextField(
          decoration:
              const InputDecoration(counterText: '', border: InputBorder.none),
          controller: _fieldController,
          autofocus: true,
          keyboardType: TextInputType.number,
          onSubmitted: (String text) {
            openSong(context, text);
          },
          textAlign: TextAlign.center,
          maxLength: 3,
          onChanged: (String data) {
            int number = -1;
            try {
              number = int.parse(data);
            } on Exception catch (_) {
              _fieldController.text = data.substring(0, data.length - 1);
            }
            if (!(number > 0 && number < 198 ||
                number > 199 && number < lastNumber)) {
              _fieldController.text = data.substring(0, data.length - 1);
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MyRaisedButton(
              'Otevřít',
              () {
                openSong(context, _fieldController.text);
              },
            ),
            MyRaisedButton(
              'Zavřít',
              () {
                Navigator.pop(context);
              },
            )
          ],
        )
      ]));
}
