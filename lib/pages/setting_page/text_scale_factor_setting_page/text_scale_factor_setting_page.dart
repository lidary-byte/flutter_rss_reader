import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting_page/setting_controller.dart';
import 'package:get/get.dart';

class TextScaleFactorSettingPage extends StatelessWidget {
  TextScaleFactorSettingPage({super.key});
  final _controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    final Map<double, String> textScaleFactorMap = {
      0.8: 'minimum'.tr,
      0.9: 'small'.tr,
      1.0: 'medium'.tr,
      1.1: 'large'.tr,
      1.2: 'maximum'.tr,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('globalScale'.tr),
      ),
      body: SafeArea(
        child: GetBuilder<SettingController>(
          builder: (_) => ListView.builder(
            itemCount: textScaleFactorMap.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: textScaleFactorMap.keys.toList()[index],
                groupValue: _controller.textScaleFactor,
                title: Text(textScaleFactorMap.values.toList()[index]),
                onChanged: (double? value) async {
                  if (value != null) {
                    await _controller.changeTextScaleFactor(value);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
