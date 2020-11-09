import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckSong extends StatelessWidget {
  CheckSong(this.song, this.id);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String id;
  final Map<String, dynamic> song;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(song['name'] as String)),
        body: Row(
          children: <String>[
            song['song'] as String,
            song['chordsSong'] as String
          ]
              .map((String entry) => SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(entry))))
              .toList(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: 'closeFAB',
              onPressed: () async {
                await _firestore.doc('checkRequired/$id').delete();
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                heroTag: 'checkFAB',
                backgroundColor: Colors.green,
                onPressed: () =>
                    _firestore.runTransaction((Transaction transaction) async {
                  final int number = ((await _firestore
                              .collection('songs')
                              .orderBy('number', descending: true)
                              .limit(1)
                              .get())
                          .docs
                          .elementAt(0)
                          .data()['number'] as int) +
                      1;
                  transaction
                    ..set(_firestore.doc('songs/$number'), <String, dynamic>{
                      'name': song['name'],
                      'song': song['chordsSong'],
                      'number': number
                    })
                    ..set(_firestore.doc('noChords/$number'), <String, dynamic>{
                      'name': song['name'],
                      'song': song['song'],
                      'number': number
                    })
                    ..delete(_firestore.doc('checkRequired/$id'));
                  Navigator.pop(context);
                }),
                child: const Icon(Icons.check),
              ),
            )
          ],
        ),
      );
}
