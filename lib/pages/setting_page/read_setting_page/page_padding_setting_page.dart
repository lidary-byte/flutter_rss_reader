import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/read_controller.dart';
import 'package:get/get.dart';

class PagePaddingSettingPage extends StatelessWidget {
  PagePaddingSettingPage({Key? key}) : super(key: key);
  final _controller = Get.put(ReadController());
  @override
  Widget build(BuildContext context) {
    final Map<int, String> pagePaddingMap = {
      0: 'minimum'.tr,
      9: 'small'.tr,
      18: 'medium'.tr,
      27: 'large'.tr,
      36: 'maximum'.tr,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('pagePadding'.tr),
      ),
      body: SafeArea(
          child: GetBuilder<ReadController>(
        builder: (_) => ListView.builder(
          itemCount: pagePaddingMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: pagePaddingMap.keys.toList()[index],
              groupValue: _controller.pagePadding,
              title: Text(pagePaddingMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  _controller.changePagePadding(value);
                }
              },
            );
          },
        ),
      )),
    );
  }
}
