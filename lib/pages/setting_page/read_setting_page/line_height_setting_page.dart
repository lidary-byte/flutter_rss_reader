import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LineHeightSettingPage extends StatelessWidget {
  const LineHeightSettingPage({Key? key}) : super(key: key);

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
            return RadioListTile(
              value: lineHeightMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().lineHeight,
              title: Text(lineHeightMap.values.toList()[index]),
              onChanged: (double? value) async {
                if (value != null) {
                  context.read<ReadPageProvider>().changeLineHeight(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
