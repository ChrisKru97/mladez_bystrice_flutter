import 'package:cloud_firestore/cloud_firestore.dart';
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
    final codaLicense =
        await rootBundle.loadString('google_fonts/coda_OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts_coda'], codaLicense);
    final hammersmithLicense =
        await rootBundle.loadString('google_fonts/hammersmith_OFL.txt');
    yield LicenseEntryWithLineBreaks(
        ['google_fonts_hammersmith'], hammersmithLicense);
    final patrickLicense =
        await rootBundle.loadString('google_fonts/patrick_OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts_patrick'], patrickLicense);
    final opensanslicense =
        await rootBundle.loadString('google_fonts/opensans_OFL.txt');
    yield LicenseEntryWithLineBreaks(
        ['google_fonts_opensans'], opensanslicense);
  });
  Firestore.instance.settings(persistenceEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  getTheme(String font, TextTheme def) {
    switch (font) {
      case 'OpenSans':
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
  Widget build(BuildContext context) {
    final SongsBloc songsBloc = SongsBloc()..loadSongs();
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (_, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.data == null) {
            return MaterialApp(
                home: Center(child: CircularProgressIndicator()));
          } else {
            final Config initialConfig = Config();
            final ConfigBloc configBloc = ConfigBloc()
              ..initFromPrefs(snapshot.data, initialConfig);
            songsBloc.initFromPrefs(snapshot.data);
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
                        brightness: snapshot.data.darkMode
                            ? Brightness.dark
                            : Brightness.light,
                        primarySwatch: snapshot.data.primary,
                        secondaryHeaderColor: snapshot.data.secondary,
                        textTheme: getTheme(
                            snapshot.data.font, Theme.of(context).textTheme),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
