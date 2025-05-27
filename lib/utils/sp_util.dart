import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  // static final SpUtil _instance = SpUtil._internal();
  // factory SpUtil() => _instance;

  // SpUtil._internal();

  static SharedPreferencesWithCache? _prefs;

  // static SpUtil? _instance;

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
}
