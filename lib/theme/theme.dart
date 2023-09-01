import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/theme/custom_theme.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';

ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: cacheThemeFont,
      colorScheme: cacheDynamicColor ? lightDynamic : null,
      colorSchemeSeed: (!cacheDynamicColor || lightDynamic == null)
          ? HexColor('#FFA400')
          : null,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
      ),
      appBarTheme: const AppBarTheme().copyWith(
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
      extensions: [
        CustomTheme(
          colorLabelColor: Colors.black,
          bottomNavigationBarBackgroundColor:
              (cacheDynamicColor && lightDynamic != null)
                  ? lightDynamic.secondaryContainer
                  : HexColor('#F5EDEB'),
          activeNavigationBarColor: (cacheDynamicColor && lightDynamic != null)
              ? lightDynamic.primary
              : HexColor('#FFA400'),
          notActiveNavigationBarColor: Colors.white,
          shadowNavigationBarColor: (cacheDynamicColor && lightDynamic != null)
              ? lightDynamic.primary
              : HexColor('#FFA400'),
        )
      ]);
}

ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: cacheThemeFont,
      colorScheme: cacheDynamicColor ? darkDynamic : null,
      colorSchemeSeed: (!cacheDynamicColor || darkDynamic == null)
          ? HexColor('#FFA400')
          : null,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
      ),
      appBarTheme: const AppBarTheme().copyWith(
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
      extensions: [
        CustomTheme(
          colorLabelColor: Colors.white,
          bottomNavigationBarBackgroundColor:
              (cacheDynamicColor && darkDynamic != null)
                  ? darkDynamic.secondaryContainer
                  : HexColor('#30271B'),
          activeNavigationBarColor: (cacheDynamicColor && darkDynamic != null)
              ? darkDynamic.primary
              : HexColor('#FFA400'),
          notActiveNavigationBarColor: Colors.white,
          shadowNavigationBarColor: (cacheDynamicColor && darkDynamic != null)
              ? darkDynamic.primary
              : HexColor('#FFA400'),
        )
      ]);
}
