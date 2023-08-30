import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting/read_setting_page/read_controller.dart';
import 'package:get/get.dart';

class FontSizeSettingPage extends StatelessWidget {
  FontSizeSettingPage({Key? key}) : super(key: key);
  final _controller = Get.put(ReadController());
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
        child: GetBuilder<ReadController>(
            builder: (_) => ListView.builder(
                  itemCount: fontSizeMap.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: fontSizeMap.keys.toList()[index],
                      groupValue: _controller.fontSize,
                      title: Text(fontSizeMap.values.toList()[index]),
                      onChanged: (int? value) {
                        if (value != null) {
                          _controller.changeFontSize(value);
                        }
                      },
                    );
                  },
                )),
      ),
    );
  }
}
