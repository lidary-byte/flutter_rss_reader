import 'dart:async';
import 'dart:io';

import 'package:agconnect_crash/agconnect_crash.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/language/message.dart';
import 'package:flutter_rss_reader/theme/theme.dart';
import 'package:fps_monitor/widget/custom_widget_inspector.dart';
import 'package:get/get.dart';

///声明NavigatorState的GlobalKey
GlobalKey<NavigatorState> globalKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await initHuawei();
  runZonedGuarded<Future<void>>(
    () async {
      runApp(const MyApp());
    },
    (dynamic error, StackTrace stackTrace) {
      AGCCrash.instance.recordError(error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) => overlayState = globalKey.currentState!.overlay!);
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
                  builder: (context, child) =>
                      CustomWidgetInspector(child: child!),
                ));
      },
    );
  }
}
