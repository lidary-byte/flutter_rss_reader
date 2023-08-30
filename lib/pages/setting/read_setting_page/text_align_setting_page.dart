import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting/read_setting_page/read_controller.dart';
import 'package:get/get.dart';

class TextAlignSettingPage extends StatelessWidget {
  TextAlignSettingPage({Key? key}) : super(key: key);
  final _controller = Get.put(ReadController());
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
                    return RadioListTile(
                      value: textAlignMap.keys.toList()[index],
                      groupValue: _controller.textAlign,
                      title: Text(textAlignMap.values.toList()[index]),
                      onChanged: (String? value) {
                        if (value != null) {
                          _controller.changeTextAlign(value);
                        }
                      },
                    );
                  },
                )),
      ),
    );
  }
}
