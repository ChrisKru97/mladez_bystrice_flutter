import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final isDarkMode = configController.init();
    Get.put(configController);
    Get.put(SongsController()..init());
    return GetMaterialApp(
      title: 'Mládežový zpěvník',
      initialRoute: '/',
      theme: ThemeData(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routingCallback: (routing) {
        switch (routing?.current) {
          case '/song':
            Wakelock.enable();
            break;
          case '/':
            configController.config.update((val) {
              if (val == null) return;
              val.songFontSize = MediaQuery.of(context).size.width / 20;
            });
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
