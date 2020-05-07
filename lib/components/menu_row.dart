import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/bloc_provider.dart';
import 'package:mladez_zpevnik/bloc/search_bloc.dart';
import 'package:mladez_zpevnik/dialogs/number_select.dart';
import 'package:mladez_zpevnik/dialogs/saved_list.dart';
import 'package:mladez_zpevnik/dialogs/search_song.dart';
import 'package:mladez_zpevnik/dialogs/settings.dart';

class MenuRow extends StatelessWidget {
  MenuRow({this.setBottomSheet, this.bottomSheetController});

  final void Function(PersistentBottomSheetController) setBottomSheet;
  final PersistentBottomSheetController bottomSheetController;

  void runFunction(Function() function) {
    if (bottomSheetController != null) {
      bottomSheetController.close();
      setBottomSheet(null);
    }
    function();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top:10),
    child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () => runFunction(() => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => SavedList()))),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => runFunction(() {
                BlocProvider.of<SearchBloc>(context).search('');
                setBottomSheet(showBottomSheet(
                    context: context,
                    builder: (_) => SearchSong(),
                    backgroundColor: Colors.transparent));
              }),
            ),
            IconButton(
                icon: Icon(
                  Icons.keyboard,
                  color: Colors.white,
                ),
                onPressed: () => runFunction(() => setBottomSheet(showBottomSheet(
                    builder: (_) => NumberSelect(),
                    context: context,
                    backgroundColor: Colors.transparent)))),
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () => runFunction(() => setBottomSheet(showBottomSheet(
                    context: context,
                    builder: (_) => Settings(),
                    backgroundColor: Colors.transparent))))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
  );
}
