import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'bloc/search_controller.dart';
import 'main_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.put(ConfigController());
    Get.put(SongsController()..loadSongs());
    Get.put(SearchController());
    return GetMaterialApp(
      title: 'Mládežový zpěvník',
      home: const MainScreen(),
      theme: ThemeData(
          brightness: configController.config.value.darkMode
              ? Brightness.dark
              : Brightness.light,
          primarySwatch: configController.config.value.primary,
          secondaryHeaderColor: configController.config.value.secondary),
    );
  }
}
