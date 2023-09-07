import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/theme/color_schemes.g.dart';
import 'package:flutter_rss_reader/theme/custom_bottom_nav_theme.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';

ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: cacheThemeFont,
      // primaryColor: Colors.blue,
      colorScheme: cacheDynamicColor
          ? lightDynamic
          : const ColorScheme.light(
              brightness: Brightness.light, primary: Colors.blue),
      // colorScheme: cacheDynamicColor ? lightDynamic : lightColorScheme,
      // listTileTheme: const ListTileThemeData().copyWith(
      //     enableFeedback: true,
      //     titleTextStyle: const TextStyle().copyWith(
      //         fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      //     subtitleTextStyle: const TextStyle().copyWith(
      //         fontSize: 10,
      //         fontWeight: FontWeight.bold,
      //         color: HexColor('#8D8D8D'))),
      cardTheme: const CardTheme().copyWith(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.all(0),
        clipBehavior: Clip.hardEdge,
      ),
      dividerTheme:
          const DividerThemeData().copyWith(color: HexColor('#8D8D8D')),
      scaffoldBackgroundColor: HexColor('#F5F5F5'),
      appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent),
      bottomAppBarTheme:
          const BottomAppBarTheme().copyWith(color: Colors.white),
      extensions: [
        CustomBottomNavTheme(
          bottomNavigationBarBackgroundColor:
              (cacheDynamicColor && lightDynamic != null)
                  ? lightDynamic.secondaryContainer
                  : Colors.white,
          // 选中
          activeNavigationBarColor: (cacheDynamicColor && lightDynamic != null)
              ? lightDynamic.primary
              : Colors.blue,
          // 未选中
          notActiveNavigationBarColor:
              (cacheDynamicColor && lightDynamic != null)
                  ? lightDynamic.onBackground
                  : lightColorScheme.onBackground,
        )
      ]);
}

ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: cacheThemeFont,
      colorScheme: cacheDynamicColor
          ? darkDynamic
          : const ColorScheme.light(
              brightness: Brightness.dark, primary: Colors.blue),
      listTileTheme: const ListTileThemeData().copyWith(
          titleTextStyle: const TextStyle().copyWith(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          subtitleTextStyle: const TextStyle().copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: HexColor('#8D8D8D'))),
      dividerTheme:
          const DividerThemeData().copyWith(color: HexColor('#8D8D8D')),
      scaffoldBackgroundColor: HexColor('#010101'),
      appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: HexColor('#121212'),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent),
      cardTheme: const CardTheme().copyWith(
        color: HexColor('#121212'),
        elevation: 0,
        margin: const EdgeInsets.all(0),
        clipBehavior: Clip.hardEdge,
      ),
      bottomAppBarTheme:
          const BottomAppBarTheme().copyWith(color: HexColor('#121212')),
      extensions: [
        CustomBottomNavTheme(
          bottomNavigationBarBackgroundColor:
              (cacheDynamicColor && darkDynamic != null)
                  ? darkDynamic.secondaryContainer
                  : HexColor('#121212'),
          // 选中
          activeNavigationBarColor: (cacheDynamicColor && darkDynamic != null)
              ? darkDynamic.primary
              : Colors.blue,
          // 未选中
          notActiveNavigationBarColor:
              (cacheDynamicColor && darkDynamic != null)
                  ? darkDynamic.onBackground
                  : Colors.white,
        )
      ]);
}
