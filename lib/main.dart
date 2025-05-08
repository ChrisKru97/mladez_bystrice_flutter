import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/playlist_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/classes/store.dart';
import 'package:mladez_zpevnik/screens/favorite_list.dart';
import 'package:mladez_zpevnik/screens/history_list.dart';
import 'package:mladez_zpevnik/firebase_options.dart';
import 'package:mladez_zpevnik/screens/playlist.dart';
import 'package:mladez_zpevnik/screens/playlists.dart';
import 'package:mladez_zpevnik/screens/present_playlist.dart';
import 'package:mladez_zpevnik/screens/present_song.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';
import 'package:mladez_zpevnik/song_display.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'main_screen.dart';

late ObjectBox objectbox;
const primaryColor = Color.fromRGBO(165, 201, 175, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final analyticsService = AnalyticsService();
  Get.put(analyticsService);

  await FirebaseAuth.instance.signInAnonymously();
  objectbox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configController = ConfigController();
    final config = configController.init();
    final songsController = SongsController()..loadSongs(config: config);
    Get.put(configController);
    Get.put(songsController);
    Get.put(PlaylistController()..init());
    return GetMaterialApp(
      title: 'Mládežový zpěvník',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(143, 181, 250, 1),
            foregroundColor: Colors.white,
            elevation: 6,
            scrolledUnderElevation: 6,
            shadowColor: Colors.black45,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
          ),
          primaryColor: primaryColor,
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF88A691), //Color.fromRGBO(249, 199, 145, 1),
              outlineVariant: Colors.black12),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(143, 181, 222, 1)),
          textTheme: GoogleFonts.interTextTheme()),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              elevation: 0,
              scrolledUnderElevation: 0),
          primaryColor: Colors.black,
          colorScheme: const ColorScheme.dark(
              primary: Colors.black, outlineVariant: Colors.white24),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              foregroundColor: Colors.black87, backgroundColor: Colors.grey),
          textTheme: GoogleFonts.interTextTheme()),
      routingCallback: (routing) {
        switch (routing?.current) {
          case '/song':
            WakelockPlus.enable();
            break;
          case '/':
            WakelockPlus.disable();
            break;
        }
      },
      getPages: [
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(name: '/song', page: () => const SongDisplay()),
        GetPage(name: '/present-song', page: () => PresentSong()),
        GetPage(name: '/favorite', page: () => const FavoriteList()),
        GetPage(name: '/history', page: () => const HistoryList()),
        GetPage(name: '/playlists', page: () => const Playlists()),
        GetPage(name: '/playlist', page: () => const PlaylistDisplay()),
        GetPage(name: '/present-playlist', page: () => const PresentPlaylist())
      ],
    );
  }
}
