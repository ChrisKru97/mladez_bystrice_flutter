import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/search_bloc.dart';
import '../dialogs/add_song.dart';
import '../dialogs/check_new_songs.dart';
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
  final void Function(PersistentBottomSheetController<int>?) setBottomSheet;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 20),
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
                onPressed: () => Navigator.of(context)!.push(
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
                      builder: (_) => SearchSong(),
                      backgroundColor: Colors.transparent)
                    ..closed.then((_) =>
                        BlocProvider.of<SearchBloc>(context)!.search('')))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.keyboard,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      builder: (_) => NumberSelect(lastNumber),
                      context: context,
                      backgroundColor: Colors.transparent))),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context)!.push(
                      CupertinoPageRoute<void>(
                          builder: (BuildContext context) => HistoryList()))),
            ),
            if (kIsWeb)
              ButtonContainer(
                child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.of(context)!.push(
                        CupertinoPageRoute<void>(
                            builder: (BuildContext _) => AddSong(context)))),
              ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () => setBottomSheet(showBottomSheet(
                      context: context,
                      builder: (_) => Settings(),
                      backgroundColor: Colors.transparent))),
            ),
            if (!kReleaseMode)
              ButtonContainer(
                child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.of(context)!.push(
                        CupertinoPageRoute<void>(
                            builder: (BuildContext _) => CheckNewSongs()))),
              )
          ],
        ),
      );
}
