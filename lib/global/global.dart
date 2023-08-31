import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
String applicationVersion = 'v0.5.0';

String cacheLaunage = '';
int cacheThemeIndex = 0;
String cacheThemeFont = '默认字体';
bool cacheDynamicColor = false;

/// 字体缩放
double cacheTextScaleFactor = 1.0;

const List themeMode = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

Future<void> init() async {
  prefs = await SharedPreferences.getInstance();
  await readThemeFont(); // 读取主题字体

  cacheLaunage = prefs.getString(ComConstant.spKeyLanguage) ?? '';
  cacheThemeIndex = prefs.getInt(ComConstant.spKeyTheme) ?? 0;
  cacheTextScaleFactor =
      prefs.getDouble(ComConstant.spKeyTextScaleFactor) ?? 1.0;
  cacheThemeFont = prefs.getString(ComConstant.spKeyThemeFont) ?? '默认字体';
  cacheDynamicColor = prefs.getBool(ComConstant.spKeyDynamicColor) ?? false;
}
