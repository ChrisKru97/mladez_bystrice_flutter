import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' show json;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mladez_zpevnik/numberSelect.dart';
import 'package:mladez_zpevnik/songDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongBook extends StatefulWidget {
  SongBook(
      {Key key,
      this.preferences,
      this.songFontSize,
      this.showChords,
      this.saveSettings})
      : super(key: key);
  final SharedPreferences preferences;
  final double songFontSize;
  final bool showChords;
  final saveSettings;
  @override
  _SongBookState createState() => _SongBookState(
      preferences: this.preferences,
      songFontSize: this.songFontSize,
      showChords: this.showChords,
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
  double songFontSize;
  bool showChords;
  var saveSettings;

  _SongBookState(
      {this.preferences,
      this.songFontSize,
      this.showChords,
      this.saveSettings});

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

  bool _searchOpen = false;
  String _search = "";
  final Set<int> _saved = Set<int>();
  final ScrollController _controller = ScrollController();

  Future<List<Song>> _loadSongs() async {
    String data;
    if (showChords)
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
            songFontSize: songFontSize,
            showChords: showChords,
            saveSettings: saveSettings);
      },
    ));
  }

  _showDialog(song) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Color primary = DynamicTheme.of(context).data.primaryColor;
          Color secondary = DynamicTheme.of(context).data.secondaryHeaderColor;
          Brightness brightness = DynamicTheme.of(context).brightness;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: Text('Odebrat z oblíbených ' + song.name + '?'),
            actions: <Widget>[
              OutlineButton(
                textColor:
                    brightness == Brightness.dark ? Colors.white : primary,
                highlightedBorderColor:
                    brightness == Brightness.dark ? Colors.white : primary,
                child: Text('Zrušit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                  highlightColor: secondary,
                  color:
                      brightness == Brightness.dark ? Colors.black38 : primary,
                  child:
                      Text('Potvrdit', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      _saved.remove(song.number);
                      preferences.setString(
                          'favorites', json.encode(_saved.toList()));
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
                Color primary = DynamicTheme.of(context).data.primaryColor;
                Color secondary =
                    DynamicTheme.of(context).data.secondaryHeaderColor;
                Brightness brightness = DynamicTheme.of(context).brightness;
                if (snapshot.data == null) {
                  return SpinKitDoubleBounce(color: secondary);
                }
                List<int> saved = _saved.toList();
                saved.sort((a, b) {
                  return a.compareTo(b);
                });
                final Iterable<ListTile> tiles = saved.map(
                  (int number) {
                    if (number > 197) number = number - 2;
                    Song song =
                        (snapshot.data as List<Song>).elementAt(number - 1);
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
                    backgroundColor: brightness == Brightness.dark
                        ? Colors.black12
                        : primary,
                    title: Text('Oblíbené'),
                  ),
                  body: ListView(children: divided),
                );
              });
        },
      ),
    );
  }

  _chooseNumber() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: _loadSongs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return SpinKitFadingCircle(
                      color:
                          DynamicTheme.of(context).data.secondaryHeaderColor);
                }
                return NumberSelect(
                    songs: snapshot.data,
                    preferences: preferences,
                    songFontSize: songFontSize,
                    showChords: showChords,
                    saveSettings: saveSettings);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DynamicTheme.of(context).data.primaryColor,
        title: _searchOpen
            ? TextField(
                autofocus: true,
                onChanged: (String search) {
                  setState(() {
                    _search = search;
                  });
                },
                decoration: InputDecoration(
                    labelStyle: new TextStyle(color: Colors.white),
                    hintText: "Hledej...",
                    hintStyle: new TextStyle(color: Colors.white)))
            : Text('Písně'),
        leading: IconButton(
          icon: Icon(Icons.keyboard),
          onPressed: _chooseNumber,
        ),
        actions: (<Widget>[
          IconButton(
              icon: Icon(_searchOpen ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (_searchOpen) {
                    _search = "";
                  }
                  _searchOpen = !_searchOpen;
                });
              }),
          IconButton(
              icon: Icon(Icons.format_list_bulleted), onPressed: _pushSaved),
        ]),
      ),
      body: FutureBuilder(
        future: _loadSongs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return SpinKitFadingCircle(
                color: DynamicTheme.of(context).data.secondaryHeaderColor);
          }
          List<Song> songs = snapshot.data;
          if (_search.length > 0) {
            songs = songs
                .where((Song song) =>
                    song.name.toLowerCase().contains(_search.toLowerCase()) ||
                    song.song.toLowerCase().contains(_search.toLowerCase()) ||
                    song.number.toString().contains(_search.toLowerCase()))
                .toList();
          }
          return DraggableScrollbar.arrows(
              backgroundColor:
                  DynamicTheme.of(context).data.secondaryHeaderColor,
              padding: EdgeInsets.only(right: 4.0),
              labelTextBuilder: (double offset) => Text(
                  ((offset ~/ 91) + 1).toString(),
                  style: TextStyle(color: Colors.white)),
              controller: _controller,
              child: ListView.separated(
                  controller: _controller,
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black12,
                      ),
                  itemCount: songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Song song = songs[index];
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
                                color: alreadySaved
                                    ? Colors.red
                                    : DynamicTheme.of(context).data.brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
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
