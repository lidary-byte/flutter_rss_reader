import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  String language = prefs.getString('language') ?? 'local';
  int themeIndex = prefs.getInt('themeIndex') ?? 2;
  String themeFont = prefs.getString('themeFont') ?? '默认字体';
  double textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
  bool isDynamicColor = prefs.getBool('dynamicColor') ?? false;

  Future<void> changeLanguage(String language) async {
    this.language = language;
    await prefs.setString('language', language);

    Get.updateLocale(Locale(
        language == 'local' ? Platform.localeName.split("_")[0] : language));
    update();
  }

  Future<void> changeThemeIndex(int index) async {
    await prefs.setInt('themeIndex', index);
    themeIndex = index;
    update();
  }

  Future<void> changeThemeFont(String font) async {
    await prefs.setString('themeFont', font);
    themeFont = font;
    update();
  }

  Future<void> changeTextScaleFactor(double factor) async {
    await prefs.setDouble('textScaleFactor', factor);
    textScaleFactor = factor;
    update();
  }

  Future<void> changeDynamicColor(bool dynamicColor) async {
    await prefs.setBool('dynamicColor', dynamicColor);
    isDynamicColor = dynamicColor;
    update();
  }
}
