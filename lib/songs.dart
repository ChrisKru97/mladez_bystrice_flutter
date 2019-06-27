import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show json;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongBook extends StatefulWidget {
  SongBook({Key key, this.preferences, this.config}) : super(key: key);
  final SharedPreferences preferences;
  final Config config;
  @override
  _SongBookState createState() =>
      _SongBookState(preferences: this.preferences, config: this.config);
}

class Song {
  final int number;
  final String name;
  final String song;

  Song(this.number, this.name, this.song);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          name == other.name &&
          song == other.song;

  @override
  int get hashCode => name.hashCode ^ song.hashCode ^ number.hashCode;

  toJson() {
    return {
      'number': number,
      'name': name,
      'song': song,
    };
  }

  String toString() {
    return json.encode(this);
  }
}

class _SongBookState extends State<SongBook> {
  SharedPreferences preferences;
  Config config;

  _SongBookState({this.preferences, this.config});

  @override
  void initState() {
    String asString = preferences.getString('favorites') ?? '';
    if (asString != '') {
      var data = json.decode(asString);
      for (var e in data) {
        _saved.add(Song(
          e['number'],
          e['name'],
          e['song'],
        ));
      }
    }
    super.initState();
  }

  final Set<Song> _saved = Set<Song>();
  final ScrollController _controller = ScrollController();

  Future<List<Song>> _loadSongs() async {
    String data = await rootBundle.loadString('assets/zpevnik.json');
    var decoded = await json.decode(data);
    List<Song> songs = [];
    for (var s in decoded) {
      songs.add(Song(s['number'], s['name'], s['song']));
    }
    return songs;
  }

  _openSong(Song song) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
//          backgroundColor: config.darkMode ? Colors.black26 : Colors.white,
          appBar: AppBar(
            backgroundColor: config.primary,
            title: Text(song.number.toString() + '. ' + song.name),
          ),
          body: SingleChildScrollView(
              child: Center(
                  child: Text(
                song.song,
                style: TextStyle(fontSize: config.songFontSize.toDouble()),
                textAlign: TextAlign.center,
              )),
              padding: EdgeInsets.all(5.0)),
        );
      },
    ));
  }

  _showDialog(song) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: Text('Smazat ' + song.name + '?'),
            actions: <Widget>[
              OutlineButton(
                textColor: config.primary,
                highlightedBorderColor: config.primary,
                child: Text('Zrušit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                  highlightColor: config.primary,
                  color: config.primary,
                  child:
                      Text('Potvrdit', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    setState(() {
                      _saved.remove(song);
                      preferences.setString(
                          'favorites', json.encode(_saved.toList()));
                    });
                  }),
            ],
          );
        });
  }

  _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          List<Song> saved = _saved.toList();
          saved.sort((a, b) {
            return a.number.compareTo(b.number);
          });
          final Iterable<ListTile> tiles = saved.map(
            (Song song) {
              return ListTile(
                title: Text(
                  song.number.toString() + '. ' + song.name,
                ),
                onTap: () {
                  _openSong(song);
                },
                onLongPress: () {
                  _showDialog(song);
                },
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: config.primary,
              title: Text('Oblíbené'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Písně'),
        actions: (<Widget>[
          IconButton(
              icon: Icon(Icons.format_list_bulleted), onPressed: _pushSaved),
        ]),
      ),
      body: FutureBuilder(
        future: _loadSongs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return SpinKitFadingCircle(
                color: Theme.of(context).secondaryHeaderColor);
          }
          return (DraggableScrollbar.arrows(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              padding: EdgeInsets.only(right: 4.0),
              labelTextBuilder: (double offset) => Text(
                  ((offset ~/ 92) + 1).toString(),
                  style: TextStyle(color: Colors.white)),
              controller: _controller,
              child: ListView.separated(
                  controller: _controller,
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black12,
                      ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Song song = snapshot.data[index];
                    final bool alreadySaved = _saved.contains(song);
                    return ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: Text(song.number.toString() + '. ' + song.name),
                        onTap: () {
                          _openSong(song);
                        },
                        trailing: IconButton(
                            icon: Icon(
                                alreadySaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    alreadySaved ? Colors.red : Colors.black),
                            onPressed: () {
                              setState(() {
                                if (alreadySaved) {
                                  _saved.remove(song);
                                } else {
                                  _saved.add(song);
                                }
                                preferences.setString(
                                    'favorites', json.encode(_saved.toList()));
                              });
                            }));
                  })));
        },
      ),
    );
  }
}
