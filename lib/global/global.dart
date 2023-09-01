import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Isar isar;
late SharedPreferences prefs;
late String applicationVersion = 'v0.5.0';

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
  //初始化数据库
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [FeedSchema, PostSchema],
    directory: dir.path,
  );

  /// 存储当前数据库版本
  prefs.setInt('db_version', 1);

  cacheLaunage = prefs.getString(ComConstant.spKeyLanguage) ?? '';
  cacheThemeIndex = prefs.getInt(ComConstant.spKeyTheme) ?? 0;
  cacheTextScaleFactor =
      prefs.getDouble(ComConstant.spKeyTextScaleFactor) ?? 1.0;
  cacheThemeFont = prefs.getString(ComConstant.spKeyThemeFont) ?? '默认字体';
  cacheDynamicColor = prefs.getBool(ComConstant.spKeyDynamicColor) ?? false;
}
