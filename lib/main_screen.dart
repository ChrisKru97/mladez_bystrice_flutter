import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/config_controller.dart';
import 'package:mladez_zpevnik/screens/songs_with_search.dart';
import 'components/menu_row.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configController = Get.find<ConfigController>();
    return Scaffold(
      appBar: AppBar(
          title: SizedBox(
              width: min(Get.width * 0.65, 400),
              child: const FittedBox(
                  child: Text(
                'Mládežový zpěvník',
              )))),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          const SongsWithSearch(),
          Builder(builder: (context) {
            WidgetsBinding.instance.addPersistentFrameCallback(
              (_) {
                final height = context.size?.height;
                if (height != null) {
                  configController.bottomBarHeight.value = height;
                }
              },
            );
            return ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: const MenuRow()),
            );
          })
        ],
      ),
    );
  }
}
