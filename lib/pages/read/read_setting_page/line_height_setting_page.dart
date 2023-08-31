import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:get/get.dart';

class LineHeightSettingPage extends StatelessWidget {
  LineHeightSettingPage({Key? key}) : super(key: key);
  final _controller = Get.find<ReadController>();
  @override
  Widget build(BuildContext context) {
    final Map<double, String> lineHeightMap = {
      1.0: 'minimum'.tr,
      1.2: 'small'.tr,
      1.5: 'medium'.tr,
      1.8: 'large'.tr,
      2.0: 'maximum'.tr,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('lineHeight'.tr),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: lineHeightMap.length,
          itemBuilder: (context, index) {
            return GetBuilder<ReadController>(
                id: 'line_height',
                builder: (_) => RadioListTile(
                    value: lineHeightMap.keys.toList()[index],
                    groupValue: _controller.lineHeight,
                    title: Text(lineHeightMap.values.toList()[index]),
                    onChanged: _controller.changeLineHeight));
          },
        ),
      ),
    );
  }
}
