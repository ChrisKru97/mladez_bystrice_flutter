import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/config.dart';
import 'package:mladez_zpevnik/main.dart';

class ConfigController extends GetxController {
  final configBox = objectbox.store.box<Config>();
  final Rx<Config> config = Config().obs;
  final Rx<double> bottomBarHeight = 0.0.obs;

  Config init() {
    if (configBox.isEmpty()) return config.value;
    final configVal = configBox.get(1);
    if (configVal != null) config.value = configVal;
    return configVal ?? config.value;
  }

  @override
  void onInit() {
    ever(
        config,
        (config) =>
            config.lastFirestoreFetch != null ? configBox.put(config) : null);
    super.onInit();
  }
}
