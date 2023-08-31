import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
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
        child: ListView.builder(
          itemCount: themeMode.length,
          itemBuilder: (context, index) {
            return GetBuilder<GlobalController>(
                id: 'theme',
                builder: (_) => RadioListTile(
                      value: index,
                      groupValue: cacheThemeIndex,
                      title: Text(themeMode[index]),
                      onChanged: (int? value) {
                        if (value != null) {
                          _controller.changeThemeIndex(value);
                        }
                      },
                    ));
          },
        ),
      ),
    );
  }
}
