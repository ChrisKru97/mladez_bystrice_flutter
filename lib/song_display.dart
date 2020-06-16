import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/hand_cursor.dart';
import 'package:universal_html/html.dart' hide Text;
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';
import 'components/favorite_icon.dart';
import 'dialogs/font_settings.dart';

class SongDisplay extends StatefulWidget {
  const SongDisplay(this._number, {Key key}) : super(key: key);
  final int _number;

  @override
  _SongDisplayState createState() => _SongDisplayState();
}

class _SongDisplayState extends State<SongDisplay> {
  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    final fontFamily = provider.fontFamily;
    double sizeCoeff = 2;
    switch (fontFamily) {
      case "OpenSans":
        sizeCoeff = 4;
        break;
      case "Patrick":
        sizeCoeff = 2.6;
        break;
      case "Coda":
        sizeCoeff = 2;
        break;
      case "Hammersmith":
        sizeCoeff = 1.9;
        break;
    }
    final Song song = BlocProvider.of<SongsBloc>(context)
        .getSong(widget._number, showChords: provider.showChords);
    final title = '${song.number}. ${song.name}';
    final titleSize =
        ((MediaQuery.of(context).size.width - 100) / title.length) * sizeCoeff;
    return Scaffold(
      appBar: AppBar(
        leading: HandCursor(child: BackButton()),
        flexibleSpace: SafeArea(
            child: Center(
                child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: titleSize < 38 ? titleSize : 38),
        ))),
        actions: <Widget>[FavoriteIcon(song.number, white: true)],
      ),
      body: StreamBuilder<Config>(
          stream: provider.stream,
          builder: (BuildContext context, AsyncSnapshot<Config> snapshot) {
            if (snapshot.data == null) {
              provider.refresh();
              return Center(child: CircularProgressIndicator());
            }
            final double fontSize = snapshot.data.songFontSize;
            final textWidget = Text(
              song.song,
              textAlign:
                  snapshot.data.alignCenter ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                  fontSize: fontSize,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
            );
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
                double newFontSize = fontSize * pow(scaleDetails.scale, 1 / 16);
                if (newFontSize >= 40) {
                  newFontSize = 40;
                } else if (newFontSize <= 12) {
                  newFontSize = 12;
                }
                provider.updateConfig('songFontSize', newFontSize);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: snapshot.data.alignCenter
                    ? Center(child: textWidget)
                    : textWidget,
              ),
            );
          }),
      floatingActionButton: Builder(
          builder: (BuildContext context) => Visibility(
                visible: _showFab,
                child: HandCursor(
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black54
                            : Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      window.document
                          .getElementById('app-container')
                          .style
                          .cursor = 'default';
                      setState(() {
                        _showFab = false;
                      });
                      showBottomSheet(
                              context: context,
                              builder: (_) => FontSettings(),
                              backgroundColor: Colors.transparent)
                          .closed
                          .then((_) {
                        setState(() {
                          _showFab = true;
                        });
                      });
                    },
                    child: Icon(Icons.format_size, color: Colors.white),
                  ),
                ),
              )),
    );
  }
}
