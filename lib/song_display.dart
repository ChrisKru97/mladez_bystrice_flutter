import 'dart:math';
import 'package:flutter/material.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';
import 'components/favorite_icon.dart';
import 'components/loader.dart';
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
    final Song song = BlocProvider.of<SongsBloc>(context)
        .getSong(widget._number, showChords: provider.showChords);
    return Scaffold(
      appBar: AppBar(
        title: Text('${song.number}. ${song.name}'),
        actions: <Widget>[FavoriteIcon(song.number)],
      ),
      body: StreamBuilder<Config>(
          stream: provider.stream,
          builder: (BuildContext context, AsyncSnapshot<Config> snapshot) {
            if (snapshot.data == null) {
              provider.refresh();
              return Loader();
            }
            final double fontSize = snapshot.data.songFontSize;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
                double newFontSize = fontSize * pow(scaleDetails.scale, 1 / 16);
                if (newFontSize >= 40) {
                  newFontSize = 40;
                } else if (newFontSize <= 12) {
                  newFontSize = 12;
                }
                provider.updateConfig('songFontSize', newFontSize,
                    skipAnimation: true);
              },
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: AnimatedDefaultTextStyle(
                    duration: snapshot.data.skipAnimation
                        ? const Duration(microseconds: 1)
                        : const Duration(milliseconds: 400),
                    style: TextStyle(
                        fontSize: fontSize,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    child: Text(song.song,
                        textAlign: snapshot.data.alignCenter
                            ? TextAlign.center
                            : TextAlign.justify),
                  )),
            );
          }),
      floatingActionButton: Builder(
          builder: (BuildContext context) => Visibility(
                visible: _showFab,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black54
                          : Theme.of(context).secondaryHeaderColor,
                  onPressed: () {
                    setState(() {
                      _showFab = false;
                    });
                    showBottomSheet(
                        context: context,
                        builder: (_) => FontSettings()).closed.then((_) {
                      setState(() {
                        _showFab = true;
                      });
                    });
                  },
                  child: Icon(Icons.format_size, color: Colors.white),
                ),
              )),
    );
  }
}
