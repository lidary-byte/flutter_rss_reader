import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:flutter_rss_reader/provider/theme_provider.dart';
import 'package:flutter_rss_reader/routes/home.dart';
import 'package:flutter_rss_reader/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge, // 适配 EdgeToEdge
  );
  await init(); // 初始化
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // 主题状态管理
        ChangeNotifierProvider(create: (_) => ReadPageProvider()), // 阅读页面状态管理
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MeRead',
          locale: context.watch<ThemeProvider>().language == 'local'
              ? null
              : Locale(context.watch<ThemeProvider>().language),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          theme: lightTheme(
            context,
            lightDynamic,
          ),
          darkTheme: darkTheme(
            context,
            darkDynamic,
          ),
          themeMode: [
            ThemeMode.light,
            ThemeMode.dark,
            ThemeMode.system,
          ][context.watch<ThemeProvider>().themeIndex],
          home: const HomePage(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: context.watch<ThemeProvider>().textScaleFactor,
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
