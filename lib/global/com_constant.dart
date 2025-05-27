import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ComConstant {}

abstract class ThemeConstant {
  static const int system = 0;
  static const int light = 1;
  static const int dark = 2;
  static const int dynamic = 3;
  // static const List<String> themes = [system, light, dark];

  static List<String> get themeModeDesc => [
    'followSystem'.tr,
    'lightMode'.tr,
    'darkMode'.tr,
  ];

  static ThemeMode getThemeMode(int index) {
    return ThemeMode.values[index];
  }
}

abstract class LaunageConstant {
  static Map<String, String> get launages => {
    '': 'systemLanguage'.tr,
    'zh': '简体中文',
    'en': 'English',
  };
}
