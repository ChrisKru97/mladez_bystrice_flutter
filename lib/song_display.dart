import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'classes/song.dart';
import 'components/favorite_icon.dart';
import 'dialogs/font_settings.dart';

class SongDisplay extends StatefulWidget {
  const SongDisplay(this._number, {this.song});
  final int _number;
  final Song? song;

  @override
  _SongDisplayState createState() => _SongDisplayState();
}

class _SongDisplayState extends State<SongDisplay> {
  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    Wakelock.enabled.then((bool enabled) => enabled ? null : Wakelock.enable());
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    final Song song = widget.song ??
        BlocProvider.of<SongsBloc>(context).getSong(widget._number);
    final String title = '${song.number}. ${song.name}';
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.song != null ? null : const BackButton(),
        title: FittedBox(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 38),
          ),
        ),
        actions: widget.song != null
            ? null
            : <Widget>[FavoriteIcon(song.number, white: true)],
      ),
      body: StreamBuilder<Config>(
          stream: provider.stream,
          builder: (BuildContext context, AsyncSnapshot<Config> snapshot) {
            if (snapshot.data == null) {
              provider.refresh();
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            final double fontSize = snapshot.data!.songFontSize;
            final Text textWidget = Text(
              provider.showChords ? song.withChords : song.withoutChords,
              textAlign: snapshot.data!.alignCenter
                  ? TextAlign.center
                  : TextAlign.left,
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
                child: snapshot.data!.alignCenter
                    ? Center(child: textWidget)
                    : textWidget,
              ),
            );
          }),
      floatingActionButton: widget.song == null
          ? Builder(
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
                                builder: (_) => FontSettings(bottom: bottom),
                                backgroundColor: Colors.transparent)
                            .closed
                            .then((_) {
                          setState(() {
                            _showFab = true;
                          });
                        });
                      },
                      child: const Icon(Icons.format_size, color: Colors.white),
                    ),
                  ))
          : null,
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}
