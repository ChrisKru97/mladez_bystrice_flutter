import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/jsonDateTime.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Talk extends StatefulWidget {
  Talk({Key key, this.preferences, this.config}) : super(key: key);
  final SharedPreferences preferences;
  final Config config;
  @override
  _TalkState createState() =>
      _TalkState(preferences: this.preferences, config: this.config);
}

class Message {
  final int id;
  final String sender;
  final String message;
  final JsonDateTime date;

  Message(this.id, this.sender, this.message, this.date);

  toJson() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'date': date,
    };
  }
}

class _TalkState extends State<Talk> {
  SharedPreferences preferences;
  Config config;

  _TalkState({this.preferences, this.config});

  @override
  void initState() {
    String asString = preferences.getString('talk') ?? '';
    if (asString != '') {
      List<Message> messages = [];
      var data = json.decode(asString);
      for (var e in data) {
        messages.add(Message(e['id'], e['sender'], e['message'],
            JsonDateTime(DateTime.parse(e['date']))));
      }
      _cacheMessages = messages;
    }
    super.initState();
  }

  final _myPadding = EdgeInsets.all(10.0);
  final _myDateFormat = new DateFormat.Hm().add_yMd();
  final ScrollController _controller = ScrollController();
  List<Message> _cacheMessages;

  Future<List<Message>> _getMessages() async {
    var data =
        await get('https://arcane-temple-75559.herokuapp.com/getmessages');
    var jsonData = await jsonDecode(data.body);
    List<Message> messages = [];
    for (var e in jsonData) {
      messages.add(Message(e['id'], e['sender'], e['message'],
          JsonDateTime(DateTime.parse(e['date']))));
    }
    messages.sort((a, b) {
      return b.date.value.compareTo(a.date.value);
    });
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getMessages(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null && _cacheMessages == null) {
            return SpinKitCubeGrid(
                color: Theme.of(context).secondaryHeaderColor);
          }
          if (snapshot.data != null) {
            preferences.setString('talk', json.encode(snapshot.data));
          }
          return LiquidPullToRefresh(
            onRefresh: () {
              setState(() {});
              return _getMessages();
            },
            showChildOpacityTransition: false,
            scrollController: _controller,
            child: ListView.builder(
                itemCount: (snapshot.data ?? _cacheMessages).length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  var message = (snapshot.data ?? _cacheMessages)[index];
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: _myPadding,
                            child: Linkify(
                                text: message.message,
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch ' + link.url;
                                  }
                                },
                                humanize: true,
                                style: TextStyle(
                                    fontSize: config.textSize.toDouble())),
                          ),
                          Padding(
                            padding: _myPadding,
                            child: Text(
                                _myDateFormat.format(message.date.value),
                                style: TextStyle(
                                    fontSize: config.textSize.toDouble())),
                          ),
                          Padding(
                              padding: _myPadding,
                              child: Text(
                                message.sender,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: config.textSize.toDouble()),
                              ))
                        ],
                      ));
                }),
          );
        });
  }
}
