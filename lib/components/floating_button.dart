import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/search_bloc.dart';
import '../dialogs/number_select.dart';
import '../dialogs/saved_list.dart';
import '../dialogs/search_song.dart';
import '../dialogs/settings.dart';

class FloatingButton extends StatefulWidget {
  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  final GlobalKey _fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final PopupMenu _menu = PopupMenu(
        context: context,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Theme.of(context).secondaryHeaderColor,
        lineColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Theme.of(context).secondaryHeaderColor,
        items: <MenuItem>[
          MenuItem(
              title: 'otevřít',
              image: Icon(
                Icons.keyboard,
                color: Colors.white,
              ),
              textStyle: TextStyle(color: Colors.white)),
          MenuItem(
              title: 'hledat',
              image: Icon(
                Icons.search,
                color: Colors.white,
              ),
              textStyle: TextStyle(color: Colors.white)),
          MenuItem(
              title: 'oblíbené',
              image: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              textStyle: TextStyle(color: Colors.white)),
          MenuItem(
              title: 'nastavení',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              textStyle: TextStyle(color: Colors.white))
        ],
        onClickMenu: (MenuItemProvider item) {
          switch (item.menuTitle) {
            case 'otevřít':
              showDialog(child: NumberSelect(), context: context);
              break;
            case 'hledat':
              BlocProvider.of<SearchBloc>(context).search('');
              showBottomSheet(context: context, builder: (_) => SearchSong());
              break;
            case 'nastavení':
              showDialog(context: context, child: Settings());
              break;
            case 'oblíbené':
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => SavedList()));
              break;
          }
        });
    return FloatingActionButton(
      key: _fabKey,
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        _menu.show(widgetKey: _fabKey);
      },
      child: Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
