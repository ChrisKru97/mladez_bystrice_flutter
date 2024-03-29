import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/search_bloc.dart';
import '../dialogs/history_list.dart';
import '../dialogs/number_select.dart';
import '../dialogs/saved_list.dart';
import '../dialogs/search_song.dart';
import '../dialogs/settings.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({required this.child});

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
  const MenuRow({required this.setBottomSheet, required this.lastNumber});

  final int lastNumber;
  final void Function(PersistentBottomSheetController<dynamic>?) setBottomSheet;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 20)
            .copyWith(bottom: max(20, MediaQuery.of(context).padding.bottom)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ButtonContainer(
              child: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                        builder: (BuildContext context) => SavedList())),
              ),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      context: context,
                      builder: (_) => SearchSong(
                          bottom: MediaQuery.of(context).padding.bottom),
                      backgroundColor: Colors.transparent)
                    ..closed.then((_) {
                      setBottomSheet(null);
                      BlocProvider.of<SearchBloc>(context).search('');
                    }))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.keyboard,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    final bottomSheet = showBottomSheet(
                        builder: (_) => NumberSelect(lastNumber,
                            bottom: MediaQuery.of(context).padding.bottom),
                        context: context,
                        backgroundColor: Colors.transparent);
                    bottomSheet.closed.then((value) {
                      setBottomSheet(null);
                    });
                    setBottomSheet(bottomSheet);
                  }),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                          builder: (BuildContext context) => HistoryList()))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      context: context,
                      builder: (_) => Settings(
                          bottom: MediaQuery.of(context).padding.bottom),
                      backgroundColor: Colors.transparent)
                    ..closed.then((_) {
                      setBottomSheet(null);
                    }))),
            )
          ],
        ),
      );
}
