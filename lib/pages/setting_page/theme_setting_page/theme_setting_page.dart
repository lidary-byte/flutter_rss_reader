import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/pages/setting_page/setting_controller.dart';
import 'package:get/get.dart';

class ThemeSettingPage extends StatelessWidget {
  ThemeSettingPage({super.key});
  final _controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    List<String> themeMode = ['followSystem'.tr, 'lightMode'.tr, 'darkMode'.tr];
    return Scaffold(
      appBar: AppBar(
        title: Text('themeMode'.tr),
      ),
      body: SafeArea(
        child: GetBuilder<SettingController>(
            builder: (_) => ListView.builder(
                  itemCount: themeMode.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      groupValue: cacheThemeIndex,
                      title: Text(themeMode[index]),
                      onChanged: (int? value) {
                        if (value != null) {
                          _controller.changeThemeIndex(value);
                        }
                      },
                    );
                  },
                )),
      ),
    );
  }
}
