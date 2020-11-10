import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_raised_button.dart';

const String dontShowStartingInfoKey = 'dontShowStartingInfo';

class StartingInfo extends StatefulWidget {
  @override
  _StartingInfoState createState() => _StartingInfoState();
}

class _StartingInfoState extends State<StartingInfo> {
  SharedPreferences? _prefs;
  final StreamController<bool> _dontShowStream = StreamController<bool>();

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      _prefs = prefs;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(width: 1)),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 1,
                            blurRadius: 10)
                      ]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('updating_songs.gif'))),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text('Pro načtení nových písní potáhni dolů',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.045))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Nezobrazovat znovu',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.03)),
                    StreamBuilder<bool>(
                        stream: _dontShowStream.stream,
                        builder: (_, AsyncSnapshot<bool> snapshot) => Checkbox(
                            onChanged: (bool? value) {
                              _dontShowStream.sink.add(value ?? false);
                              _prefs?.setBool(dontShowStartingInfoKey, value);
                            },
                            value: snapshot.data ?? false))
                  ]),
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: MyRaisedButton('Zavřít', () => Navigator.pop(context)))
            ],
          )));

  @override
  void dispose() {
    _dontShowStream.close();
    super.dispose();
  }
}
