import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PagePaddingSettingPage extends StatelessWidget {
  const PagePaddingSettingPage({Key? key}) : super(key: key);

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
            return RadioListTile(
              value: pagePaddingMap.keys.toList()[index],
              groupValue: context.watch<ReadPageProvider>().pagePadding,
              title: Text(pagePaddingMap.values.toList()[index]),
              onChanged: (int? value) {
                if (value != null) {
                  context.read<ReadPageProvider>().changePagePadding(value);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
