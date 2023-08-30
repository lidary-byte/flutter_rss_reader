import 'package:flutter_rss_reader/pages/feed_page/add_feed/add_feed_page.dart';
import 'package:flutter_rss_reader/pages/feed_page/edit_feed/edit_feed_page.dart';
import 'package:flutter_rss_reader/pages/feed_page/feed_page.dart';
import 'package:flutter_rss_reader/pages/home/home_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/block_setting_page/block_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/dynamic_color_setting_page/dynamic_color_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/font_setting_page/font_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/language_setting_page/language_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/read_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/text_scale_factor_setting_page/text_scale_factor_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/theme_setting_page/theme_setting_page.dart';
import 'package:get/get_navigation/get_navigation.dart';

abstract class AppRouter {
  static const String homePageRouter = '/';
  static const String feedPageRouter = '/feed_page';
  static const String addFeedPageRouter = '/add_feed_page';
  static const String editFeedPageRouter = '/edit_feed_page';
  static const String languageSettingPageRouter = '/language_setting_page';
  static const String themeSettingPageRouter = '/theme_setting_page';
  static const String dynamicColorSettingPage = '/dynamic_color_setting_page';
  static const String fontSettingPage = '/font_setting_page';
  static const String textScaleFactorSettingPage =
      '/text_scale_factor_setting_page';
  static const String readSettingPage = '/read_setting_page';
  static const String blockSettingPage = '/block_setting_page';
  static const String readPageRouter = '/read_page';

  static List<GetPage> routerPages = [
    GetPage(name: homePageRouter, page: () => HomePage()),
    GetPage(name: feedPageRouter, page: () => FeedPage()),
    GetPage(name: addFeedPageRouter, page: () => AddFeedPage()),
    GetPage(name: editFeedPageRouter, page: () => EditFeedPage()),
    GetPage(name: languageSettingPageRouter, page: () => LanguageSettingPage()),
    GetPage(name: themeSettingPageRouter, page: () => ThemeSettingPage()),
    GetPage(
        name: dynamicColorSettingPage, page: () => DynamicColorSettingPage()),
    GetPage(name: fontSettingPage, page: () => FontSettingPage()),
    GetPage(
        name: textScaleFactorSettingPage,
        page: () => TextScaleFactorSettingPage()),
    GetPage(name: readSettingPage, page: () => ReadSettingPage()),
    GetPage(name: blockSettingPage, page: () => BlockSettingPage()),
    // GetPage(name: readPageRouter, page: () => ReadPage()),
  ];
}
