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
      // colorScheme: cacheDynamicColor ? darkDynamic : darkColorScheme,
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
