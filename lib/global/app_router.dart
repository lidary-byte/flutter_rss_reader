import 'package:flutter_rss_reader/pages/feed/add_feed/add_feed_page.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_page.dart';
import 'package:flutter_rss_reader/pages/feed/feed_page.dart';
import 'package:flutter_rss_reader/pages/home/home_page.dart';
import 'package:flutter_rss_reader/pages/read/read_page.dart';
import 'package:flutter_rss_reader/pages/setting/block_setting_page/block_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting/dynamic_color_setting_page/dynamic_color_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting/font_setting_page/font_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting/language_setting_page/language_setting_page.dart';
import 'package:flutter_rss_reader/pages/read/read_setting_page/read_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting/text_scale_factor_setting_page/text_scale_factor_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting/theme_setting_page/theme_setting_page.dart';
import 'package:flutter_rss_reader/pages/web_view/web_view_page.dart';
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
  static const String webViewPageRouter = '/web_view_page';

  static List<GetPage> routerPages = [
    GetPage(name: homePageRouter, page: () => HomePage()),
    GetPage(
        name: feedPageRouter,
        page: () => FeedPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: addFeedPageRouter,
        page: () => AddFeedPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: editFeedPageRouter,
        page: () => EditFeedPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: languageSettingPageRouter,
        page: () => LanguageSettingPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: themeSettingPageRouter,
        page: () => ThemeSettingPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: dynamicColorSettingPage,
        page: () => DynamicColorSettingPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: fontSettingPage,
        page: () => FontSettingPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: textScaleFactorSettingPage,
        page: () => TextScaleFactorSettingPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: readSettingPage,
        page: () => ReadSettingPage(),
        transition: Transition.rightToLeft),
    GetPage(name: blockSettingPage, page: () => BlockSettingPage()),
    GetPage(
        name: readPageRouter,
        page: () => ReadPage(),
        transition: Transition.rightToLeft),
    GetPage(
        name: webViewPageRouter,
        page: () => WebViewPage(),
        transition: Transition.rightToLeft),
  ];
}
