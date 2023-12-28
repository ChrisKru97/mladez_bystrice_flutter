import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/classes/store.dart';
import 'package:mladez_zpevnik/dialogs/favourite_list.dart';
import 'package:mladez_zpevnik/dialogs/history_list.dart';
import 'package:mladez_zpevnik/firebase_options.dart';
import 'package:mladez_zpevnik/song_display.dart';
import 'package:wakelock/wakelock.dart';
import 'main_screen.dart';

late ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    final songsController = SongsController()..init(config);
    Get.put(configController);
    Get.put(songsController);
    return GetMaterialApp(
      title: 'Mládežový zpěvník',
      initialRoute: '/',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            // color: Color.fromRGBO(165, 201, 175, 1),
            color: Color.fromRGBO(143, 181, 250, 1),
            foregroundColor: Colors.white,
            elevation: 5,
            scrolledUnderElevation: 5,
            shadowColor: Colors.black45,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            // 249, 199, 145
          ),
          primaryColor: const Color.fromRGBO(165, 201, 175, 1),
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
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              foregroundColor: Colors.black87, backgroundColor: Colors.grey),
          textTheme: GoogleFonts.interTextTheme()),
      routingCallback: (routing) {
        switch (routing?.current) {
          case '/song':
            Wakelock.enable();
            break;
          case '/':
            Wakelock.disable();
            break;
        }
      },
      getPages: [
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(name: '/song', page: () => const SongDisplay()),
        GetPage(name: '/favourite', page: () => const FavouriteList()),
        GetPage(name: '/history', page: () => const HistoryList()),
      ],
    );
  }
}
