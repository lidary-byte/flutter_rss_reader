import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:get/get.dart';

class ThemeSettingPage extends StatelessWidget {
  ThemeSettingPage({super.key});
  final _controller = Get.find<GlobalController>();
  @override
  Widget build(BuildContext context) {
    List<String> themeMode = ['followSystem'.tr, 'lightMode'.tr, 'darkMode'.tr];
    return Scaffold(
      appBar: AppBar(
        title: Text('themeMode'.tr),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListSectionGroup(
              hasPadding: false,
              children: themeMode
                  .map((e) => GetBuilder<GlobalController>(
                      id: 'theme',
                      builder: (_) => RadioListTile.adaptive(
                            activeColor: Get.theme.primaryColor,
                            title: Text(e),
                            onChanged: (value) => _controller
                                .changeThemeIndex(themeMode.indexOf(e)),
                            value: themeMode.indexOf(e),
                            groupValue: cacheThemeIndex,
                          )))
                  .toList(),
            ),
            GetBuilder<GlobalController>(
              builder: (_) => ListSectionGroup(
                titleText: 'dynamicColor'.tr,
                children: [
                  SectionChild(
                    title: 'openDynamicColor'.tr,
                    subTitle: 'dynamicColorFromWallpaper'.tr,
                    trailing: Switch.adaptive(
                      activeColor: Get.theme.primaryColor,
                      value: cacheDynamicColor,
                      onChanged: Platform.isAndroid
                          ? _controller.changeDynamicColor
                          : null,
                    ),
                    onTap: () => Platform.isAndroid
                        ? _controller.changeDynamicColor(!cacheDynamicColor)
                        : null,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'dynamicColorInfo'.tr,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
