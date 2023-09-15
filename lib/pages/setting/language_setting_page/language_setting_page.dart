import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
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
          child: ListSectionGroup(
        hasPadding: false,
        children: languageMap.keys
            .map((e) => GetBuilder<GlobalController>(
                id: 'language',
                builder: (_) => SectionChild(
                      title: languageMap[e] ?? '',
                      trailing: Radio.adaptive(
                        activeColor: Get.theme.primaryColor,
                        value: e,
                        groupValue: cacheLaunage,
                        onChanged: (value) => _controller.changeLanguage(e),
                      ),
                      onTap: () => _controller.changeLanguage(e),
                    )))
            .toList(),
      )),
    );
  }
}
