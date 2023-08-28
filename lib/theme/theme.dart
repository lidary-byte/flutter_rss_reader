import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/provider/theme_provider.dart';
import 'package:provider/provider.dart';

ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: context.watch<ThemeProvider>().themeFont,
    colorScheme:
        context.watch<ThemeProvider>().isDynamicColor ? lightDynamic : null,
    colorSchemeSeed:
        (!context.watch<ThemeProvider>().isDynamicColor || lightDynamic == null)
            ? Colors.indigo
            : null,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    ),
  );
}

ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: context.watch<ThemeProvider>().themeFont,
    colorScheme:
        context.watch<ThemeProvider>().isDynamicColor ? darkDynamic : null,
    colorSchemeSeed:
        (!context.watch<ThemeProvider>().isDynamicColor || darkDynamic == null)
            ? Colors.indigo
            : null,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    ),
  );
}
