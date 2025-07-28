import 'dart:ui';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
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
import 'package:mladez_zpevnik/theme/app_theme.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'main_screen.dart';

late ObjectBox objectbox;
const primaryColor = Color.fromRGBO(165, 201, 175, 1);

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
      await analyticsService.logAppLaunch();
      objectbox = await ObjectBox.create();

      runApp(const MyApp());
    },
    (error, stack) {
      // Firebase error handling
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
