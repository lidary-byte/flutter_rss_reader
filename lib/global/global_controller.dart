import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/pages/home/home_controller.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  final List<String> fontNameList = []; // 字体名称列表
  // 初始化字体名称列表
  void fontList() async {
    fontNameList.clear();
    fontNameList.addAll(await readAllFont());
    update(['font_list']);
  }

  void addFont() async {
    final success = await loadLocalFont();
    if (success) {
      fontList();
    }
  }

  Future<void> changeLanguage(String language) async {
    if (language == cacheLaunage) {
      return;
    }
    cacheLaunage = language;
    await prefs.setString(ComConstant.spKeyLanguage, language);
    Get.updateLocale(
        Locale(language == '' ? Platform.localeName.split("_")[0] : language));
    update(['language']);
    Get.find<HomeController>().update();
  }

  Future<void> changeThemeIndex(int index) async {
    if (index == cacheThemeIndex) {
      return;
    }
    await prefs.setInt(ComConstant.spKeyTheme, index);
    cacheThemeIndex = index;
    Get.changeThemeMode(themeMode[index]);
    update(['theme']);
  }

  void changeThemeFont(String font) async {
    await prefs.setString(ComConstant.spKeyThemeFont, font);
    cacheThemeFont = font;
    // 刷新一下字体列表 同时刷新一下全局字体
    update(['font_list']);
    update();
  }

  void changeDynamicColor(bool dynamicColor) async {
    await prefs.setBool(ComConstant.spKeyDynamicColor, dynamicColor);
    cacheDynamicColor = dynamicColor;
    update();
  }

  @override
  void onReady() {
    super.onReady();
    fontList();
  }
}
