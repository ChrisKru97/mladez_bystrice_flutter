import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/bloc/bloc_provider.dart';
import 'package:mladez_zpevnik/bloc/search_bloc.dart';
import 'package:mladez_zpevnik/dialogs/history_list.dart';
import 'package:mladez_zpevnik/dialogs/number_select.dart';
import 'package:mladez_zpevnik/dialogs/saved_list.dart';
import 'package:mladez_zpevnik/dialogs/search_song.dart';
import 'package:mladez_zpevnik/dialogs/settings.dart';

class ButtonContainer extends StatelessWidget {
  ButtonContainer({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Center(child: child),
      );
}

class MenuRow extends StatelessWidget {
  MenuRow({this.setBottomSheet});

  final void Function(PersistentBottomSheetController) setBottomSheet;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black54,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            ButtonContainer(
              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => SavedList())),
              ),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      context: context,
                      builder: (_) => SearchSong(),
                      backgroundColor: Colors.transparent)
                    ..closed.then((_) =>
                        BlocProvider.of<SearchBloc>(context).search('')))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: Icon(
                    Icons.keyboard,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      builder: (_) => NumberSelect(),
                      context: context,
                      backgroundColor: Colors.transparent))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => HistoryList()))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      context: context,
                      builder: (_) => Settings(),
                      backgroundColor: Colors.transparent))),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      );
}
