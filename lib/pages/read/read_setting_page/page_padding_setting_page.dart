import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:get/get.dart';

class PagePaddingSettingPage extends StatelessWidget {
  PagePaddingSettingPage({Key? key}) : super(key: key);
  final _controller = Get.find<ReadController>();
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
          child: ListView.builder(
        itemCount: pagePaddingMap.length,
        itemBuilder: (context, index) {
          return GetBuilder<ReadController>(
            id: 'page_padding',
            builder: (_) {
              return RadioListTile(
                value: pagePaddingMap.keys.toList()[index],
                groupValue: _controller.pagePadding,
                title: Text(pagePaddingMap.values.toList()[index]),
                onChanged: _controller.changePagePadding,
              );
            },
          );
        },
      )),
    );
  }
}
