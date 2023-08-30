import 'dart:io';
import 'dart:ui';

import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final List<String> blockList = prefs.getStringList('blockList') ?? [];

  void removeBlock(int index) async {
    blockList.removeAt(index);
    await prefs.setStringList('blockList', blockList);
    update();
  }

  void addBlock(String text) async {
    blockList.add(text);
    await prefs.setStringList('blockList', blockList);
    update();
  }

  final List<String> fontNameList = []; // 字体名称列表
  // 初始化字体名称列表
  Future<void> fontList() async {
    fontNameList.clear();
    fontNameList.addAll(await readAllFont());
    update();
  }

  String themeFont = prefs.getString(ComConstant.spKeyThemeFont) ?? '默认字体';
  Future<void> changeThemeFont(String font) async {
    await prefs.setString(ComConstant.spKeyThemeFont, font);
    themeFont = font;
    update();
  }

  double textScaleFactor =
      prefs.getDouble(ComConstant.spKeyTextScaleFactor) ?? 1.0;
  Future<void> changeTextScaleFactor(double factor) async {
    await prefs.setDouble(ComConstant.spKeyTextScaleFactor, factor);
    textScaleFactor = factor;
    update();
  }

  /// 动态取色
  bool isDynamicColor = prefs.getBool(ComConstant.spKeyDynamicColor) ?? false;
  Future<void> changeDynamicColor(bool dynamicColor) async {
    await prefs.setBool(ComConstant.spKeyDynamicColor, dynamicColor);
    isDynamicColor = dynamicColor;
    update();
  }

  Future<void> changeThemeIndex(int index) async {
    cacheThemeIndex = index;
    await prefs.setInt(ComConstant.spKeyTheme, index);
    Get.changeThemeMode(themeMode[cacheThemeIndex]);
    update();
  }

  Future<void> changeLanguage(String language) async {
    cacheLaunage = language;
    await prefs.setString(ComConstant.spKeyLanguage, language);
    Get.updateLocale(
        Locale(language == '' ? Platform.localeName.split("_")[0] : language));
    update();
  }

  @override
  void onInit() {
    fontList();
    super.onInit();
  }
}
