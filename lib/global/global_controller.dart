import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:flutter_rss_reader/utils/sp_util.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  int _themeIndex = 0; // 主题索引
  int get themeIndex => _themeIndex;
  // 是否是动态取色
  bool _isDynamicTheme = false;
  bool get isDynamicTheme => _isDynamicTheme;
  // 语言
  String _launage = '';
  String get launage => _launage;

  final List<String> fontNameList = []; // 字体名称列表

  @override
  void onInit() async {
    super.onInit();
    _themeIndex = SpUtil.getInstance().getInt(SpKeys.spKeyTheme) ?? 0;
    _isDynamicTheme =
        SpUtil.getInstance().getBool(SpKeys.spKeyDynamicTheme) ?? false;
    _launage = SpUtil.getInstance().getString(SpKeys.spKeyLanguage) ?? '';
  }

  Future<void> changeTheme(int? index) async {
    _themeIndex = index ?? 0;
    Get.changeThemeMode(ThemeMode.values[_themeIndex]);
    SpUtil.getInstance().setInt(SpKeys.spKeyTheme, _themeIndex);
    update();
  }

  changeDynamicTheme() async {
    _isDynamicTheme = !_isDynamicTheme;
    SpUtil.getInstance().setBool(SpKeys.spKeyDynamicTheme, _isDynamicTheme);
    update();
  }

  Future<void> changeLanguage(String language) async {
    _launage = language;
    await SpUtil.getInstance().setString(SpKeys.spKeyLanguage, language);
    Get.updateLocale(
      Locale(language == '' ? Platform.localeName.split("_")[0] : language),
    );
    update();
  }

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

  void changeThemeFont(String font) async {
    await SpUtil.getInstance().setString(SpKeys.spKeyThemeFont, font);
    cacheThemeFont = font;
    // 刷新一下字体列表 同时刷新一下全局字体
    update(['font_list']);
    update();
  }

  @override
  void onReady() {
    super.onReady();
    fontList();
  }
}
