import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:wakelock/wakelock.dart';
import 'classes/song.dart';
import 'components/favorite_icon.dart';
import 'dialogs/font_settings.dart';

class SongDisplay extends StatefulWidget {
  const SongDisplay(this._number, {super.key, this.song});

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
    final ConfigController configController = Get.find();
    final Song song = widget.song ??
        Get.find<SongsController>()
            .songs
            .firstWhere((Song song) => song.number == widget._number);
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          double newFontSize = configController.config.value.songFontSize *
              pow(scaleDetails.scale, 1 / 16);
          if (newFontSize >= 40) {
            newFontSize = 40;
          } else if (newFontSize <= 12) {
            newFontSize = 12;
          }
          configController.config.value.songFontSize = newFontSize;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: configController.config.value.alignCenter
              ? Center(
                  child: Text(
                  configController.config.value.showChords
                      ? song.withChords
                      : song.withoutChords,
                  textAlign: configController.config.value.alignCenter
                      ? TextAlign.center
                      : TextAlign.left,
                  style: TextStyle(
                      fontSize: configController.config.value.songFontSize,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ))
              : Text(
                  configController.config.value.showChords
                      ? song.withChords
                      : song.withoutChords,
                  textAlign: configController.config.value.alignCenter
                      ? TextAlign.center
                      : TextAlign.left,
                  style: TextStyle(
                      fontSize: configController.config.value.songFontSize,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
        ),
      ),
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
