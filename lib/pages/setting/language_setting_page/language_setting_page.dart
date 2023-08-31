import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:get/get.dart';

class LanguageSettingPage extends StatelessWidget {
  LanguageSettingPage({super.key});
  final _controller = Get.find<GlobalController>();
  @override
  Widget build(BuildContext context) {
    final languageMap = {
      '': 'systemLanguage'.tr,
      'zh': '简体中文',
      'en': 'English',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('languageSetting'.tr),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: languageMap.length,
          itemBuilder: (context, index) {
            return GetBuilder<GlobalController>(
                id: 'language',
                builder: (_) => RadioListTile(
                      value: languageMap.keys.toList()[index],
                      groupValue: cacheLaunage,
                      title: Text(languageMap.values.toList()[index]),
                      onChanged: (value) =>
                          _controller.changeLanguage(value ?? ''),
                    ));
          },
        ),
      ),
    );
  }
}
