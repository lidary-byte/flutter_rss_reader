import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/theme/color_schemes.g.dart';
import 'package:flutter_rss_reader/theme/custom_theme.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';

ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: cacheThemeFont,
      colorScheme: cacheDynamicColor ? lightDynamic : lightColorScheme,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
      ),
      // appBarTheme: const AppBarTheme().copyWith(
      //     titleTextStyle: const TextStyle(
      //         fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
      extensions: [
        CustomTheme(
          colorLabelColor: (cacheDynamicColor && lightDynamic != null)
              ? lightDynamic.secondaryContainer
              : lightColorScheme.secondaryContainer,
          bottomNavigationBarBackgroundColor:
              (cacheDynamicColor && lightDynamic != null)
                  ? lightDynamic.secondaryContainer
                  : lightColorScheme.secondaryContainer,
          // 选中
          activeNavigationBarColor: (cacheDynamicColor && lightDynamic != null)
              ? lightDynamic.primary
              : lightColorScheme.primary,
          // 未选中
          notActiveNavigationBarColor:
              (cacheDynamicColor && lightDynamic != null)
                  ? lightDynamic.onBackground
                  : lightColorScheme.onBackground,
          shadowNavigationBarColor: (cacheDynamicColor && lightDynamic != null)
              ? lightDynamic.secondaryContainer
              : lightColorScheme.secondaryContainer,
        )
      ]);
}

ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: cacheThemeFont,
      colorScheme: cacheDynamicColor ? darkDynamic : darkColorScheme,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
      ),
      // appBarTheme: const AppBarTheme().copyWith(
      //     titleTextStyle: const TextStyle(
      //         fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
      extensions: [
        CustomTheme(
          colorLabelColor: (cacheDynamicColor && darkDynamic != null)
              ? darkDynamic.secondaryContainer
              : lightColorScheme.secondaryContainer,
          bottomNavigationBarBackgroundColor:
              (cacheDynamicColor && darkDynamic != null)
                  ? darkDynamic.secondaryContainer
                  : darkColorScheme.secondaryContainer,
          // 选中
          activeNavigationBarColor: (cacheDynamicColor && darkDynamic != null)
              ? darkDynamic.primary
              : darkColorScheme.primary,
          // 未选中
          notActiveNavigationBarColor:
              (cacheDynamicColor && darkDynamic != null)
                  ? darkDynamic.onBackground
                  : darkColorScheme.onBackground,
          shadowNavigationBarColor: (cacheDynamicColor && darkDynamic != null)
              ? darkDynamic.secondaryContainer
              : darkColorScheme.secondaryContainer,
        )
      ]);
}
