import 'dart:async';

import 'package:flutter_rss_reader/database/database_helper.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// late SharedPreferences prefs;
// late SharedPreferencesWithCache prefsWithCache;

late String applicationVersion = 'v0.5.0';

String cacheLaunage = '';
// int cacheThemeIndex = 0;
String cacheThemeFont = '默认字体';
// bool cacheDynamicColor = false;

// const List themeMode = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
// List<String> get themeModeDesc => [
//   'followSystem'.tr,
//   'lightMode'.tr,
//   'darkMode'.tr,
// ];

Future<void> init() async {
  // prefs = await SharedPreferences.getInstance();
  await readThemeFont(); // 读取主题字体

  // cacheLaunage = prefs.getString(ComConstant.spKeyLanguage) ?? '';
  // cacheThemeIndex = prefs.getInt(ComConstant.spKeyTheme) ?? 0;
  // logger.e("------------主题:$cacheThemeIndex");
  // cacheThemeFont = prefs.getString(ComConstant.spKeyThemeFont) ?? '默认字体';
  // cacheDynamicColor = prefs.getBool(ComConstant.spKeyDynamicColor) ?? false;

  await initIsar();
  // 初始化services
  // await Get.putAsync(() => ParseFeedServices().init());
  Get.lazyPut(() => ParseFeedServices());
}
