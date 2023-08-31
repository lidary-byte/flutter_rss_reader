import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:get/get.dart';

class FontSizeSettingPage extends StatelessWidget {
  FontSizeSettingPage({Key? key}) : super(key: key);
  final _controller = Get.find<ReadController>();
  @override
  Widget build(BuildContext context) {
    final Map<int, String> fontSizeMap = {
      14: 'minimum'.tr,
      16: 'small'.tr,
      18: 'medium'.tr,
      20: 'large'.tr,
      22: 'maximum'.tr,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('fontSize'.tr),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: fontSizeMap.length,
          itemBuilder: (context, index) {
            return GetBuilder<ReadController>(
                id: 'font_size',
                builder: (_) => RadioListTile(
                      value: fontSizeMap.keys.toList()[index],
                      groupValue: _controller.fontSize,
                      title: Text(fontSizeMap.values.toList()[index]),
                      onChanged: _controller.changeFontSize,
                    ));
          },
        ),
      ),
    );
  }
}
