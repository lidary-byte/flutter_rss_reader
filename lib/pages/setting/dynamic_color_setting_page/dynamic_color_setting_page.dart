import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:get/get.dart';

class DynamicColorSettingPage extends StatelessWidget {
  DynamicColorSettingPage({Key? key}) : super(key: key);
  final _controller = Get.find<GlobalController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dynamicColor'.tr),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          GetBuilder<GlobalController>(
            builder: (_) => SwitchListTile(
              value: cacheDynamicColor,
              onChanged: _controller.changeDynamicColor,
              title: Text('openDynamicColor'.tr),
              subtitle: Text('dynamicColorFromWallpaper'.tr),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text('dynamicColorInfo'.tr),
          ),
        ],
      )),
    );
  }
}
