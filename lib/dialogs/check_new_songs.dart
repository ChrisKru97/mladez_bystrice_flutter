import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/check_song.dart';

class CheckNewSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Nové písně'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('checkRequired')
              .snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) => snapshot
                  .hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, int index) => ListTile(
                        onTap: () => Navigator.of(context)!.push(
                            CupertinoPageRoute<void>(
                                builder: (BuildContext _) => CheckSong(
                                    snapshot.data!.docs.elementAt(index).data(),
                                    snapshot.data!.docs.elementAt(index).id))),
                        title: Text(snapshot.data!.docs
                            .elementAt(index)
                            ?.data()['name'] as String),
                      ))
              : const Center(child: CircularProgressIndicator()),
        ),
      );
}
