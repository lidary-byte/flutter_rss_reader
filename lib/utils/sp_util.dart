import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static SharedPreferencesWithCache? _prefs;

  SpUtil._internal();

  // 初始化
  static Future<void> init() async {
    _prefs ??= await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{
          SpKeys.spKeyDynamicTheme,
          SpKeys.spKeyLanguage,
          SpKeys.spKeyTheme,
          SpKeys.spKeyThemeFont,
          SpKeys.spKeyTextScaleFactor,
          SpKeys.spKeyDBVersion,
          SpKeys.spKeyFontSize,
          SpKeys.spKeyLineHeight,
          SpKeys.spKeyPagePadding,
          SpKeys.spKeyTextAlign,
          SpKeys.spKeyCustomCss,
        },
      ),
    );
  }

  static SharedPreferencesWithCache getInstance() {
    assert(
      _prefs != null,
      'SharedPreferences is not initialized. Call SpUtil.init() first.',
    );
    return _prefs!;
  }
}

abstract class SpKeys {
  static const spKeyLanguage = "language";
  static const spKeyTheme = 'theme';
  static const spKeyDynamicTheme = 'dynamic_theme';
  static const spKeyThemeFont = 'themeFont';
  static const spKeyTextScaleFactor = 'textScaleFactor';
  static const spKeyDBVersion = "db_version";

  static const spKeyFontSize = 'fontSize';
  static const spKeyLineHeight = 'lineheight';
  static const spKeyPagePadding = 'pagePadding';
  static const spKeyTextAlign = 'textAlign';
  static const spKeyCustomCss = 'customCss';
}
