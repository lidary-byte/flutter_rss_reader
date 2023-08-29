import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FontSizeSettingPage extends StatelessWidget {
  const FontSizeSettingPage({Key? key}) : super(key: key);

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
            return RadioListTile(
              value: fontSizeMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().fontSize,
              title: Text(fontSizeMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changeFontSize(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
