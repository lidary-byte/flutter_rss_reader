import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/custom_css_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/font_size_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/line_height_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/page_padding_setting_page.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/read_controller.dart';
import 'package:flutter_rss_reader/pages/setting_page/read_setting_page/text_align_setting_page.dart';
import 'package:get/get.dart';

class ReadSettingPage extends StatelessWidget {
  ReadSettingPage({super.key});
  final _controller = Get.put(ReadController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('readingPage'.tr),
      ),
      body: SafeArea(
        child: GetBuilder<ReadController>(
            builder: (_) => ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.text_increase_outlined),
                      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                      title: Text('fontSize'.tr),
                      subtitle: Text(
                        {
                              14: 'minimum'.tr,
                              16: 'small'.tr,
                              18: 'medium'.tr,
                              20: 'large'.tr,
                              22: 'maximum'.tr,
                            }[_controller.fontSize] ??
                            'medium'.tr,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => FontSizeSettingPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.vertical_distribute_outlined),
                      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                      title: Text('lineHeight'.tr),
                      subtitle: Text(
                        {
                              1.0: 'minimum'.tr,
                              1.2: 'small'.tr,
                              1.5: 'medium'.tr,
                              1.8: 'large'.tr,
                              2.0: 'maximum'.tr,
                            }[_controller.lineHeight] ??
                            'medium'.tr,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LineHeightSettingPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.space_bar_outlined),
                      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                      title: Text('pagePadding'.tr),
                      subtitle: Text(
                        {
                              0: 'minimum'.tr,
                              9: 'small'.tr,
                              18: 'medium'.tr,
                              27: 'large'.tr,
                              36: 'maximum'.tr,
                            }[_controller.pagePadding] ??
                            'medium'.tr,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PagePaddingSettingPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.format_align_left_outlined),
                      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                      title: Text('textAlignment'.tr),
                      subtitle: Text(
                        {
                              'left': 'leftAlignment'.tr,
                              'right': 'rightAlignment'.tr,
                              'center': 'centerAlignment'.tr,
                              'justify': 'justifyAlignment'.tr,
                            }[_controller.textAlign] ??
                            'justifyAlignment'.tr,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => TextAlignSettingPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.code_outlined),
                      iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                      title: Text('customCSS'.tr),
                      subtitle: Text('readingPageCSSStyle'.tr),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CustomCssPage(),
                          ),
                        );
                      },
                    ),
                  ],
                )),
      ),
    );
  }
}
