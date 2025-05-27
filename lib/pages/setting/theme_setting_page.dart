import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:get/get.dart';

class ThemeSettingPage extends GetView<GlobalController> {
  const ThemeSettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('themeMode'.tr)),
      body: SafeArea(
        child: GetBuilder<GlobalController>(
          builder: (_) => ListView(
            children: [
              ...ThemeConstant.themeModeDesc.map(
                (e) => RadioListTile.adaptive(
                  value: ThemeConstant.themeModeDesc.indexOf(e),
                  title: Text(e),

                  groupValue: controller.themeIndex,
                  onChanged: controller.isDynamicTheme
                      ? null
                      : controller.changeTheme,
                ),
              ),

              Divider(height: 0.5),
              Padding(
                padding: EdgeInsetsGeometry.fromSTEB(18.0, 32.0, 0.0, 10.0),
                child: Text('dynamicColor'.tr),
              ),
              ListTile(
                enabled: Platform.isAndroid,
                title: Text('openDynamicColor'.tr),
                subtitle: Text('dynamicColorFromWallpaper'.tr),
                trailing: Switch.adaptive(
                  value: controller.isDynamicTheme,
                  onChanged: Platform.isAndroid ? (value) {} : null,
                  // onChanged: Platform.isAndroid
                  //     ? globalController.changeDynamicColor
                  //     : null,
                ),
                onTap: controller.changeDynamicTheme,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Text(
                  'dynamicColorInfo'.tr,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
