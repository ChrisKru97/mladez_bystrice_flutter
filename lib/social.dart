import 'package:flutter/material.dart';
import 'package:mladez_zpevnik/config.dart';
import 'package:mladez_zpevnik/events.dart';
import 'package:mladez_zpevnik/talk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class Social extends StatefulWidget {
  Social({Key key, this.preferences, this.config}) : super(key: key);
  final SharedPreferences preferences;
  final Config config;

  @override
  _SocialState createState() =>
      _SocialState(preferences: this.preferences, config: this.config);
}

class _SocialState extends State<Social> {
  final SharedPreferences preferences;
  final Config config;
  bool _showFAB = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  _SocialState({this.preferences, this.config});

  _openNewMessage(parentContext) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.blue, width: 3.0)),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextFormField(
                                      autocorrect: false,
                                      autofocus: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Zadej zprávu!';
                                        }
                                        return null;
                                      },
                                      controller: _messageController,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Zpráva')))),
                          Flexible(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextFormField(
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Zadej jméno!';
                                        }
                                        return null;
                                      },
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue)),
                                          labelText: 'Tvé jméno')))),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    OutlineButton(
                                      textColor: Colors.blue,
                                      child: Text('Zrušit'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    RaisedButton(
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        child: Text('Poslat'),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            http
                                                .post(
                                                    'https://arcane-temple-75559.herokuapp.com/addmessages',
                                                    headers: {
                                                      'Content-Type':
                                                          'application/json',
                                                      'Accept':
                                                          'application/json'
                                                    },
                                                    body: json.encode({
                                                      'sender': _nameController
                                                          .value.text,
                                                      'message':
                                                          _messageController
                                                              .value.text,
                                                      'date': DateTime.now()
                                                          .millisecondsSinceEpoch,
                                                    }))
                                                .then((response) {
                                              Navigator.pop(context);
                                              if (response.statusCode == 200) {
                                                _messageController.text = '';
                                                _nameController.text = '';
                                                setState(() {});
                                                Scaffold.of(parentContext)
                                                    .showSnackBar(SnackBar(
                                                        content: Row(
                                                  children: <Widget>[
                                                    Text('Úspěšně odesláno')
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                )));
                                              }
                                            });
                                          }
                                        })
                                  ])),
                        ]))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            floatingActionButton: _showFAB
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _openNewMessage(context);
                    },
                  )
                : Center(),
            backgroundColor: Colors.black12,
//        backgroundColor: config.darkMode ? Colors.black87 : Colors.white,
            appBar: AppBar(
                bottom: TabBar(
              onTap: (index) {
                setState(() {
                  _showFAB = index == 1;
                });
              },
              tabs: <Widget>[
                Tab(icon: Icon(Icons.date_range)),
                Tab(icon: Icon(Icons.chat)),
              ],
            )),
            body: TabBarView(children: <Widget>[Events(), Talk()])));
  }
}
