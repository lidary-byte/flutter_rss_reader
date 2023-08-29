import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting_page/setting_controller.dart';
import 'package:get/get.dart';

class DynamicColorSettingPage extends StatelessWidget {
  DynamicColorSettingPage({Key? key}) : super(key: key);
  final _controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dynamicColor'.tr),
      ),
      body: SafeArea(
          child: GetBuilder<SettingController>(
        builder: (_) => ListView(
          children: [
            SwitchListTile(
              value: _controller.isDynamicColor,
              onChanged: _controller.changeDynamicColor,
              title: Text('openDynamicColor'.tr),
              subtitle: Text('dynamicColorFromWallpaper'.tr),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text('dynamicColorInfo'.tr),
            ),
          ],
        ),
      )),
    );
  }
}
