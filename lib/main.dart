import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/bloc_provider.dart';
import 'bloc/config_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/songs_bloc.dart';
import 'classes/config.dart';
import 'main_screen.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final String codaLicense =
        await rootBundle.loadString('google_fonts/coda_OFL.txt');
    yield LicenseEntryWithLineBreaks(
        <String>['google_fonts_coda'], codaLicense);
    final String hammersmithLicense =
        await rootBundle.loadString('google_fonts/hammersmith_OFL.txt');
    yield LicenseEntryWithLineBreaks(
        <String>['google_fonts_hammersmith'], hammersmithLicense);
    final String patrickLicense =
        await rootBundle.loadString('google_fonts/patrick_OFL.txt');
    yield LicenseEntryWithLineBreaks(
        <String>['google_fonts_patrick'], patrickLicense);
    final String opensanslicense =
        await rootBundle.loadString('google_fonts/opensans_OFL.txt');
    yield LicenseEntryWithLineBreaks(
        <String>['google_fonts_opensans'], opensanslicense);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  TextTheme getTheme(String font, TextTheme def) {
    switch (font) {
      case 'Open':
        return GoogleFonts.openSansTextTheme(def);
      case 'Patrick':
        return GoogleFonts.patrickHandTextTheme(def);
      case 'Coda':
        return GoogleFonts.codaTextTheme(def);
      case 'Hammersmith':
        return GoogleFonts.hammersmithOneTextTheme(def);
    }
    return def;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
      future: Future.wait(<Future<dynamic>>[
        SharedPreferences.getInstance(),
        Firebase.initializeApp()
      ]),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const MaterialApp(
              home: Center(child: CircularProgressIndicator()));
        } else {
          final Config initialConfig = Config();
          final ConfigBloc configBloc = ConfigBloc()
            ..initFromPrefs(
                snapshot.data![0] as SharedPreferences, initialConfig);
          final SongsBloc songsBloc = SongsBloc()
            ..initFromPrefs(snapshot.data![0] as SharedPreferences);
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
                    title: 'Mládež Bystřice',
                    home: MainScreen(),
                    theme: ThemeData(
                      brightness: (snapshot.data?.darkMode ?? false)
                          ? Brightness.dark
                          : Brightness.light,
                      primarySwatch: snapshot.data?.primary,
                      secondaryHeaderColor: snapshot.data?.secondary,
                      textTheme: getTheme(snapshot.data?.font ?? '',
                          Theme.of(context).textTheme),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      });
}
