import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:get/get.dart';

class TextAlignSettingPage extends StatelessWidget {
  TextAlignSettingPage({Key? key}) : super(key: key);
  final _controller = Get.find<ReadController>();
  @override
  Widget build(BuildContext context) {
    final Map<String, String> textAlignMap = {
      'left': 'leftAlignment'.tr,
      'right': 'rightAlignment'.tr,
      'center': 'centerAlignment'.tr,
      'justify': 'justifyAlignment'.tr,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('textAlignment'.tr),
      ),
      body: SafeArea(
        child: GetBuilder<ReadController>(
            builder: (_) => ListView.builder(
                  itemCount: textAlignMap.length,
                  itemBuilder: (context, index) {
                    return GetBuilder<ReadController>(
                        id: 'text_alignment',
                        builder: (_) => RadioListTile(
                              value: textAlignMap.keys.toList()[index],
                              groupValue: _controller.textAlign,
                              title: Text(textAlignMap.values.toList()[index]),
                              onChanged: _controller.changeTextAlign,
                            ));
                  },
                )),
      ),
    );
  }
}
