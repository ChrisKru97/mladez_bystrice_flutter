import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../classes/song.dart';
import '../components/my_raised_button.dart';
import '../song_display.dart';

class AddSong extends StatefulWidget {
  const AddSong(this.parentContext, {this.song, this.chordsText});

  final Song? song;
  final String? chordsText;
  final BuildContext parentContext;

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<bool> _chordsStream = StreamController<bool>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _chordSongController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.song != null) {
      _nameController.text = widget.song!.name;
      _songController.text = widget.song!.song;
      _chordSongController.text = widget.chordsText;
    }
    final double width = MediaQuery.of(context).size.width * 0.4;
    final double height = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(),
            flexibleSpace: const SafeArea(
                child: Center(
                    child: Text(
              'Přidat píseň',
              style: TextStyle(color: Colors.white, fontSize: 30),
            )))),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: width,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextField(
                      enableSuggestions: false,
                      decoration: const InputDecoration(labelText: 'Název'),
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
                        decoration: const InputDecoration(labelText: 'Text'),
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
                        decoration:
                            const InputDecoration(labelText: 'Text s akordy'),
                        controller: _chordSongController,
                        onChanged: (_) => _chordsStream.sink.add(true),
                      ),
                    ),
                    Builder(
                        builder: (BuildContext context) => MyRaisedButton(
                                widget.song != null
                                    ? 'Uprav'
                                    : 'Odešli ke kontrole', () {
                              if (_nameController.text.isEmpty ||
                                  _songController.text.isEmpty ||
                                  _chordSongController.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text('Chybí data',
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.redAccent[400],
                                ));
                              } else {
                                _firestore.runTransaction(
                                    (Transaction transaction) async {
                                  try {
                                    if (widget.song != null) {
                                      transaction
                                        ..update(
                                            _firestore.doc(
                                                'noChords/${widget.song!.number}'),
                                            <String, dynamic>{
                                              'name': _nameController.text,
                                              'song': _songController.text,
                                              'number': widget.song!.number
                                            })
                                        ..update(
                                            _firestore.doc(
                                                'songs/${widget.song!.number}'),
                                            <String, dynamic>{
                                              'name': _nameController.text,
                                              'song': _chordSongController.text,
                                              'number': widget.song!.number
                                            });
                                    } else {
                                      transaction.set(
                                          _firestore.doc(
                                              'checkRequired/${UniqueKey().toString()}'),
                                          <String, String>{
                                            'name': _nameController.text,
                                            'song': _songController.text,
                                            'chordsSong':
                                                _chordSongController.text
                                          });
                                    }
                                    ScaffoldMessenger.of(widget.parentContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        widget.song != null
                                            ? 'Upraveno'
                                            : 'Přídáno',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      backgroundColor: Colors.greenAccent[100],
                                    ));
                                    Navigator.pop(context);
                                  } on Exception catch (_) {}
                                });
                              }
                            }))
                  ],
                ),
              ),
              Container(
                  decoration: const BoxDecoration(boxShadow: <BoxShadow>[
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
                      builder: (_, AsyncSnapshot<bool> snapshot) => SongDisplay(
                          1,
                          song: Song(
                              number: 1,
                              name: _nameController.text,
                              song: snapshot.data ?? false
                                  ? _chordSongController.text
                                  : _songController.text))))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _chordsStream.close();
    super.dispose();
  }
}
