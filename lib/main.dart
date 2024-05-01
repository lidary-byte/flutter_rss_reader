import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/language/message.dart';
import 'package:flutter_rss_reader/theme/color_schemes.g.dart';
import 'package:get/get.dart';

///声明NavigatorState的GlobalKey
GlobalKey<NavigatorState> globalKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // BackgroundIsolateBinaryMessenger.ensureInitialized(
  //     RootIsolateToken.instance!);
  GestureBinding.instance.resamplingEnabled = true;
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
  // 初始化
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return GetBuilder<GlobalController>(
            init: GlobalController(),
            builder: (_) => GetMaterialApp(
                  navigatorKey: globalKey,
                  debugShowCheckedModeBanner: false,
                  title: 'AReader',
                  locale: cacheLaunage.isBlank == true
                      ? Locale(Platform.localeName.split("_").first)
                      : Locale(cacheLaunage),
                  // 防止Local 找不到
                  fallbackLocale: const Locale('en'),
                  translations: Message(),
                  // theme: lightTheme(
                  //   context,
                  //   lightDynamic,
                  // ),
                  // darkTheme: darkTheme(
                  //   context,
                  //   darkDynamic,
                  // ),
                  theme: ThemeData(
                      useMaterial3: true, colorScheme: lightColorScheme),
                  darkTheme: ThemeData(
                      useMaterial3: true, colorScheme: darkColorScheme),
                  themeMode: themeMode[cacheThemeIndex],
                  initialRoute: AppRouter.homePageRouter,
                  getPages: AppRouter.routerPages,
                ));
      },
    );
  }
}
