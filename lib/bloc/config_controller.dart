import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/config.dart';
import 'package:mladez_zpevnik/main.dart';

class ConfigController extends GetxController {
  final configBox = objectbox.store.box<Config>();
  Rx<Config> config = Config().obs;

  bool init() {
    if (configBox.isEmpty()) return false;
    final configVal = configBox.get(1);
    config.update((val) {
      val = configVal;
    });
    return configVal?.isDarkMode ?? false;
  }

  @override
  void onInit() {
    ever(config, (config) => configBox.put(config));
    super.onInit();
  }
}
