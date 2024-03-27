import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/database/database_helper.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

late SharedPreferences prefs;
late String applicationVersion = 'v0.5.0';

String cacheLaunage = '';
int cacheThemeIndex = 0;
String cacheThemeFont = '默认字体';
bool cacheDynamicColor = false;

const List themeMode = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

Future<void> init() async {
  prefs = await SharedPreferences.getInstance();
  await readThemeFont(); // 读取主题字体

  cacheLaunage = prefs.getString(ComConstant.spKeyLanguage) ?? '';
  cacheThemeIndex = prefs.getInt(ComConstant.spKeyTheme) ?? 0;

  cacheThemeFont = prefs.getString(ComConstant.spKeyThemeFont) ?? '默认字体';
  cacheDynamicColor = prefs.getBool(ComConstant.spKeyDynamicColor) ?? false;

  await initIsar();
  // 初始化services
  await Get.putAsync(() => ParseFeedServices().init());
}
