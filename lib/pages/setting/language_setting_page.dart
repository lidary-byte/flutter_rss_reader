import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:get/get.dart';

class LanguageSettingPage extends GetView<GlobalController> {
  const LanguageSettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('languageSetting'.tr)),
      body: SafeArea(
        child: GetBuilder<GlobalController>(
          builder: (_) => ListView(
            children: [
              ...LaunageConstant.launages.keys.map(
                (e) => RadioListTile.adaptive(
                  value: e,
                  title: Text(LaunageConstant.launages[e] ?? ''),

                  groupValue: controller.launage,
                  onChanged: (value) {
                    controller.changeLanguage(e);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
