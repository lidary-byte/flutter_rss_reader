import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/pages/home/home_controller.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  Future<void> changeLanguage(String language) async {
    if (language == cacheLaunage) {
      return;
    }
    cacheLaunage = language;
    await prefs.setString('language', language);
    Get.updateLocale(
        Locale(language == '' ? Platform.localeName.split("_")[0] : language));
    update(['language']);
    Get.find<HomeController>().update();
  }

  Future<void> changeThemeIndex(int index) async {
    if (index == cacheThemeIndex) {
      return;
    }
    await prefs.setInt('themeIndex', index);
    cacheThemeIndex = index;
    Get.changeThemeMode(themeMode[index]);
    update(['theme']);
  }

  Future<void> changeThemeFont(String font) async {
    await prefs.setString(ComConstant.spKeyThemeFont, font);
    cacheThemeFont = font;
    update(['font']);
  }

  Future<void> changeTextScaleFactor(double factor) async {
    await prefs.setDouble(ComConstant.spKeyTextScaleFactor, factor);
    cacheTextScaleFactor = factor;
    update();
  }

  Future<void> changeDynamicColor(bool dynamicColor) async {
    await prefs.setBool(ComConstant.spKeyDynamicColor, dynamicColor);
    cacheDynamicColor = dynamicColor;
    update();
  }
}
