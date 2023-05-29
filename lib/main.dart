import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
      future: Future.wait(<Future<dynamic>>[
        SharedPreferences.getInstance(),
        Firebase.initializeApp(),
      ]),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const MaterialApp(
              home: Center(child: CircularProgressIndicator.adaptive()));
        } else {
          final Config initialConfig = Config();
          final ConfigBloc configBloc = ConfigBloc()
            ..initFromPrefs(
                snapshot.data![0] as SharedPreferences, initialConfig);
          final SongsBloc songsBloc = SongsBloc();
          FirebaseAuth.instance.signInAnonymously().then((_) =>
              songsBloc.initFromPrefs(snapshot.data![0] as SharedPreferences));
          return BlocProvider<ConfigBloc>(
            bloc: configBloc,
            child: BlocProvider<SongsBloc>(
              bloc: songsBloc,
              child: BlocProvider<SearchBloc>(
                bloc: SearchBloc(),
                child: StreamBuilder<Config>(
                  stream: configBloc.stream,
                  initialData: initialConfig,
                  builder: (_, AsyncSnapshot<Config> snapshot) => MaterialApp(
                    title: 'Mládežový zpěvník',
                    home: MainScreen(),
                    theme: ThemeData(
                      brightness: (snapshot.data?.darkMode ?? false)
                          ? Brightness.dark
                          : Brightness.light,
                      primarySwatch: snapshot.data?.primary,
                      secondaryHeaderColor: snapshot.data?.secondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      });
}
