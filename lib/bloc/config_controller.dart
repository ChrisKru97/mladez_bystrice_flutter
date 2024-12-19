import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mladez_zpevnik/classes/config.dart';

class ConfigController extends GetxController {
  final Rx<Config> config = Config().obs;
  final Rx<double> bottomBarHeight = 0.0.obs;

  Config init() {
    final asString = GetStorage().read('config');
    if (asString != null) {
      final configVal = Config.fromJson(jsonDecode(asString));
      config.value = configVal;
    }
    return config.value;
  }

  @override
  void onInit() {
    ever(config, (config) => GetStorage().write('config', jsonEncode(config)));
    super.onInit();
  }
}
