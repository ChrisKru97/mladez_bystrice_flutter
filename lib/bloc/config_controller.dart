import 'package:get/get.dart';
import 'package:mladez_zpevnik/classes/config.dart';
import 'package:mladez_zpevnik/main.dart';

class ConfigController extends GetxController {
  final configBox = objectbox.store.box<Config>();
  Rx<Config> config = Config().obs;

  Config? init() {
    if (configBox.isEmpty()) return null;
    final configVal = configBox.get(1);
    if (configVal != null) config.value = configVal;
    return configVal;
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
