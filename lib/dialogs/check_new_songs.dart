import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/components/check_song.dart';

class CheckNewSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Nové písně'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('checkRequired').snapshots(),
          builder: (_, snapshot) => snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) => ListTile(
                        onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                                builder: (BuildContext _) => CheckSong(
                                    snapshot.data.documents
                                        .elementAt(index)
                                        .data,
                                    snapshot.data.documents
                                        .elementAt(index)
                                        .documentID))),
                        title: Text(snapshot.data.documents
                            .elementAt(index)
                            ?.data['name']),
                      ))
              : Center(child: CircularProgressIndicator()),
        ),
      );
}
