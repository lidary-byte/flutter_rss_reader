import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:get/get.dart';

class FontSettingPage extends StatelessWidget {
  FontSettingPage({super.key});
  final _controller = Get.find<GlobalController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('globalFont'.tr),
        actions: [
          // 添加字体
          IconButton(
            onPressed: () => _controller.addFont(),
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<GlobalController>(
            id: 'font_list',
            builder: (_) => ListView(
                  children: _fontWidget(),
                )),
      ),
    );
  }

  List<Widget> _fontWidget() {
    final widgets = <Widget>[];
    widgets.add(ListSectionGroup(
      children: [
        SectionChild(
          title: 'defaultFont'.tr,
          trailing: Radio.adaptive(
              activeColor: Get.theme.primaryColor,
              value: '默认字体',
              groupValue: cacheThemeFont,
              onChanged: (value) => _controller.changeThemeFont('默认字体')),
          onTap: () => _controller.changeThemeFont('默认字体'),
        )
      ],
    ));
    widgets.add(ListSectionGroup(
      children: _controller.fontNameList
          .map((e) => SectionChild(
                titleWidget:
                    Text(e.split('.').first, style: TextStyle(fontFamily: e)),
                trailing: Radio.adaptive(
                  activeColor: Get.theme.primaryColor,
                  value: e,
                  groupValue: cacheThemeFont,
                  onChanged: (value) => _controller.changeThemeFont(e),
                ),
                onTap: () => _controller.changeThemeFont(e),
              ))
          .toList(),
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'fontInfo'.tr,
      ),
    ));
    return widgets;
  }
}
