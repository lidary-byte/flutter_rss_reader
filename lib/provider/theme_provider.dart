import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';

class ThemeProvider extends ChangeNotifier {
  String language = prefs.getString('language') ?? 'local';
  int themeIndex = prefs.getInt('themeIndex') ?? 2;
  String themeFont = prefs.getString('themeFont') ?? '默认字体';
  double textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.0;
  bool isDynamicColor = prefs.getBool('dynamicColor') ?? false;

  Future<void> changeLanguage(String language) async {
    await prefs.setString('language', language);
    setState(() {
      this.language = language;
    });
  }

  Future<void> changeThemeIndex(int index) async {
    await prefs.setInt('themeIndex', index);
    setState(() {
      themeIndex = index;
    });
  }

  Future<void> changeThemeFont(String font) async {
    await prefs.setString('themeFont', font);
    setState(() {
      themeFont = font;
    });
  }

  Future<void> changeTextScaleFactor(double factor) async {
    await prefs.setDouble('textScaleFactor', factor);
    setState(() {
      textScaleFactor = factor;
    });
  }

  Future<void> changeDynamicColor(bool dynamicColor) async {
    await prefs.setBool('dynamicColor', dynamicColor);
    setState(() {
      isDynamicColor = dynamicColor;
    });
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
