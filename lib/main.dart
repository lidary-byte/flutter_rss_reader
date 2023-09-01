import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/global/message.dart';
import 'package:flutter_rss_reader/theme/theme.dart';
import 'package:get/get.dart';

void main() async {
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
                  debugShowCheckedModeBanner: false,
                  title: 'AReader',
                  locale: cacheLaunage.isBlank == true
                      ? Locale(Platform.localeName.split("_").first)
                      : Locale(cacheLaunage),
                  // 防止Local 找不到
                  fallbackLocale: const Locale('en'),
                  translations: Message(),
                  theme: lightTheme(
                    context,
                    lightDynamic,
                  ),
                  darkTheme: darkTheme(
                    context,
                    darkDynamic,
                  ),
                  themeMode: themeMode[cacheThemeIndex],
                  initialRoute: AppRouter.homePageRouter,
                  getPages: AppRouter.routerPages,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: cacheTextScaleFactor,
                      ),
                      child: child!,
                    );
                  },
                ));
      },
    );
  }
}
