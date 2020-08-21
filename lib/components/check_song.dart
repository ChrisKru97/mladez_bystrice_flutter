import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckSong extends StatelessWidget {
  CheckSong(this.song, this.id);

  final Firestore _firestore = Firestore.instance;
  final String id;
  final Map<String, dynamic> song;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(song['name'])),
        body: Row(
          children: [song['song'], song['chordsSong']]
              .map((current) => SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(current))))
              .toList(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'closeFAB',
              backgroundColor: Colors.red,
              child: Icon(Icons.close),
              onPressed: () {
                _firestore.runTransaction((transaction) async {
                  await transaction
                      .delete(_firestore.document('checkRequired/$id'));
                  Navigator.pop(context);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                heroTag: 'checkFAB',
                backgroundColor: Colors.green,
                child: Icon(Icons.check),
                onPressed: () {
                  _firestore.runTransaction((transaction) async {
                    final number = (await _firestore
                                .collection('songs')
                                .orderBy('number', descending: true)
                                .limit(1)
                                .getDocuments())
                            .documents
                            .elementAt(0)
                            .data['number'] +
                        1;
                    await transaction.set(
                        _firestore.document('songs/${number}'), {
                      'name': song['name'],
                      'song': song['chordsSong'],
                      'number': number
                    });
                    await transaction.set(
                        _firestore.document('noChords/${number}'), {
                      'name': song['name'],
                      'song': song['song'],
                      'number': number
                    });
                    await transaction
                        .delete(_firestore.document('checkRequired/$id'));
                    Navigator.pop(context);
                  });
                },
              ),
            )
          ],
        ),
      );
}
