import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _initializeSystemTheme();
    _updateSystemUI();
  }

  void _initializeSystemTheme() {
    _themeMode.value = ThemeMode.system;
    _isDarkMode.value = Get.isPlatformDarkMode;
    Get.changeThemeMode(ThemeMode.system);
  }


  // Theme is always system mode - no user control
  void updateSystemMode() {
    _isDarkMode.value = Get.isPlatformDarkMode;
    _updateSystemUI();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: _isDarkMode.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: _isDarkMode.value ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _isDarkMode.value ? const Color(0xFF1F2937) : Colors.white,
        systemNavigationBarIconBrightness: _isDarkMode.value ? Brightness.light : Brightness.dark,
      ),
    );
  }

  String get currentThemeName => 'Systém';
  
  IconData get currentThemeIcon => Icons.brightness_auto_rounded;
}
