import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TextAlignSettingPage extends StatelessWidget {
  const TextAlignSettingPage({Key? key}) : super(key: key);

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
        child: ListView.builder(
          itemCount: textAlignMap.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              value: textAlignMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().textAlign,
              title: Text(textAlignMap.values.toList()[index]),
              onChanged: (String? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changeTextAlign(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
