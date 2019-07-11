import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show json;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/songDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongBook extends StatefulWidget {
  SongBook({Key key, this.preferences, this.config, this.saveSettings})
      : super(key: key);
  final SharedPreferences preferences;
  final Config config;
  final saveSettings;
  @override
  _SongBookState createState() => _SongBookState(
      preferences: this.preferences,
      config: this.config,
      saveSettings: this.saveSettings);
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
          number == other.number;

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
  var saveSettings;

  _SongBookState({this.preferences, this.config, this.saveSettings});

  @override
  void initState() {
    String asString = preferences.getString('favorites') ?? '';
    if (asString != '') {
      var data = json.decode(asString);
      if ((data as List).first.runtimeType.toString() == 'int') {
        for (var e in data) {
          _saved.add(e);
        }
      } else {
        for (var e in data) {
          _saved.add(e['number']);
        }
      }
    }
    super.initState();
  }

  final Set<int> _saved = Set<int>();
  final ScrollController _controller = ScrollController();

  Future<List<Song>> _loadSongs() async {
    String data;
    if (config.showChords ?? false)
      data = await rootBundle.loadString('assets/zpevnik.json');
    else {
      data = await rootBundle.loadString('assets/noChords.json');
    }
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
        return SongDisplay(
            song: song,
            preferences: preferences,
            config: config,
            saveSettings: saveSettings);
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
          return FutureBuilder(
              future: _loadSongs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return SpinKitDoubleBounce(
                      color: Theme.of(context).secondaryHeaderColor);
                }
                List<int> saved = _saved.toList();
                saved.sort((a, b) {
                  return a.compareTo(b);
                });
                final Iterable<ListTile> tiles = saved.map(
                  (int number) {
                    if (number > 196) number = number - 4;
                    Song song =
                        (snapshot.data as List<Song>).elementAt(number + 1);
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
              });
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
          return DraggableScrollbar.arrows(
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
                    final bool alreadySaved = _saved.contains(song.number);
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
                                  _saved.remove(song.number);
                                } else {
                                  _saved.add(song.number);
                                }
                                preferences.setString(
                                    'favorites', json.encode(_saved.toList()));
                              });
                            }));
                  }));
        },
      ),
    );
  }
}
