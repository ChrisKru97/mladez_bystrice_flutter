import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/jsonDateTime.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Events extends StatefulWidget {
  Events({Key key, this.preferences, this.config}) : super(key: key);
  final SharedPreferences preferences;
  final Config config;
  @override
  _EventsState createState() =>
      _EventsState(preferences: this.preferences, config: this.config);
}

class Event {
  final int id;
  final String title;
  final String description;
  final String author;
  final JsonDateTime date;
  final bool show;

  toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'date': date,
      'show': show
    };
  }

  Event(
      {this.id,
      this.title,
      this.description,
      this.author,
      this.date,
      this.show});

  String toString() {
    return json.encode(this);
  }
}

class _EventsState extends State<Events> {
  SharedPreferences preferences;
  Config config;

  _EventsState({this.preferences, this.config});

  @override
  void initState() {
    String asString = preferences?.getString('events') ?? '';
    if (asString != '') {
      List<Event> events = [];
      var data = json.decode(asString);
      for (var e in data) {
        events.add(Event(
            id: e['id'],
            title: e['title'],
            description: e['description'],
            author: e['author'],
            date: JsonDateTime(DateTime.parse(e['date'])),
            show: e['show']));
      }
      _cacheEvents = events;
    }
    super.initState();
  }

  final _myPadding = EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0);
  final _myDateFormat = new DateFormat.Hm().add_yMd();
  final ScrollController _scrollController = ScrollController();
  List<Event> _cacheEvents;

  Future<List<Event>> _getEvents() async {
    var data = await get('https://arcane-temple-75559.herokuapp.com/getdata');
    var jsonData = await json.decode(data.body);
    List<Event> events = [];
    for (var e in jsonData) {
      events.add(Event(
          id: e['id'],
          title: e['title'],
          description: e['description'],
          author: e['author'],
          date: JsonDateTime(DateTime.parse(e['date'])),
          show: e['show']));
    }
    events.sort((a, b) {
      return b.date.value.compareTo(a.date.value);
    });
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getEvents(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null && _cacheEvents == null) {
            return SpinKitWave(color: Colors.green[500]);
          }
          if (snapshot.data != null) {
            preferences?.setString('events', json.encode(snapshot.data));
          }
          return LiquidPullToRefresh(
            onRefresh: () {
              setState(() {});
              return _getEvents();
            },
            showChildOpacityTransition: false,
            scrollController: _scrollController,
            child: ListView.builder(
                itemCount: (snapshot.data ?? _cacheEvents).length,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  Event event = (snapshot.data ?? _cacheEvents)[index];
                  return Card(
//                color: config.darkMode ? Colors.black87 : Colors.white,
                      elevation: 5,
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                              child: Text(
                                event.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                            Divider(color: Colors.black),
                            Padding(
                              padding: _myPadding,
                              child: Linkify(
                                text: event.description,
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch ' + link.url;
                                  }
                                },
                                humanize: true,
                              ),
                            ),
                            Padding(
                              padding: _myPadding,
                              child:
                                  Text(_myDateFormat.format(event.date.value)),
                            ),
                            event.show
                                ? Padding(
                                    padding: _myPadding,
                                    child: Text(
                                      event.author,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                                : Center()
                          ]));
                }),
          );
        });
  }
}
