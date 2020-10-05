import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/classes/song.dart';
import 'package:mladez_zpevnik/components/my_raised_button.dart';
import 'package:mladez_zpevnik/song_display.dart';

class AddSong extends StatelessWidget {
  AddSong(this.parentContext, {this.song, this.chordsText});

  final Song song;
  final String chordsText;
  final BuildContext parentContext;
  final _firestore = FirebaseFirestore.instance;
  final StreamController _chordsStream = StreamController<bool>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _chordSongController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (song != null) {
      _nameController.text = song.name;
      _songController.text = song.song;
      _chordSongController.text = chordsText;
    }
    final width = MediaQuery.of(context).size.width * 0.4;
    final height = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
        appBar: AppBar(
            leading: BackButton(),
            flexibleSpace: SafeArea(
                child: Center(
                    child: Text(
              'Přidat píseň',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )))),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: width,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      enableSuggestions: false,
                      decoration: InputDecoration(labelText: 'Název'),
                      controller: _nameController,
                      autocorrect: false,
                      onChanged: (_) => _chordsStream.sink.add(false),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height / 3),
                      child: TextField(
                        onTap: () => _chordsStream.sink.add(false),
                        enableSuggestions: false,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: 'Text'),
                        autocorrect: false,
                        controller: _songController,
                        onChanged: (_) => _chordsStream.sink.add(false),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: height / 3),
                      child: TextField(
                        onTap: () => _chordsStream.sink.add(true),
                        enableSuggestions: false,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autocorrect: false,
                        decoration: InputDecoration(labelText: 'Text s akordy'),
                        controller: _chordSongController,
                        onChanged: (_) => _chordsStream.sink.add(true),
                      ),
                    ),
                    Builder(
                        builder: (context) => MyRaisedButton(
                                song != null ? 'Uprav' : 'Odešli ke kontrole',
                                () {
                              if (_nameController.text.isEmpty ||
                                  _songController.text.isEmpty ||
                                  _chordSongController.text.isEmpty) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Chybí data',
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.redAccent[400],
                                ));
                              } else {
                                _firestore.runTransaction((transaction) async {
                                  try {
                                    if (song != null) {
                                      await transaction.update(
                                          _firestore
                                              .doc('noChords/${song.number}'),
                                          {
                                            'name': _nameController.text,
                                            'song': _songController.text,
                                            'number': song.number
                                          });
                                      await transaction.update(
                                          _firestore
                                              .doc('songs/${song.number}'),
                                          {
                                            'name': _nameController.text,
                                            'song': _chordSongController.text,
                                            'number': song.number
                                          });
                                    } else {
                                      await transaction.set(
                                          _firestore.doc(
                                              'checkRequired/${UniqueKey().toString()}'),
                                          {
                                            'name': _nameController.text,
                                            'song': _songController.text,
                                            'chordsSong':
                                                _chordSongController.text
                                          });
                                    }
                                    Scaffold.of(parentContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        song != null ? 'Upraveno' : 'Přídáno',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      backgroundColor: Colors.greenAccent[100],
                                    ));
                                    Navigator.pop(context);
                                  } catch (_) {}
                                });
                              }
                            }))
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(1, 1),
                        color: Colors.black45)
                  ]),
                  width: width,
                  height: height,
                  child: StreamBuilder<bool>(
                      stream: _chordsStream.stream,
                      initialData: false,
                      builder: (_, snapshot) => SongDisplay(1,
                          song: Song(
                              number: 1,
                              name: _nameController.text,
                              song: snapshot.data
                                  ? _chordSongController.text
                                  : _songController.text))))
            ],
          ),
        ));
  }
}
