import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final _controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        elevation: 0,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          ListSectionGroup(
            titleText: 'personalization'.tr,
            children: [
              _themeWidget(),
              _languageWidget(),
              _fontWidget(),
            ],
          ),
          ListSectionGroup(
            titleText: 'dataManagement'.tr,
            children: [
              SectionChild(
                icon: Icons.app_blocking_outlined,
                iconColor: Colors.red,
                title: 'blockRules'.tr,
                subTitle: 'setPostBlockRule'.tr,
                onTap: () => Get.toNamed(AppRouter.blockSettingPage),
              ),
              SectionChild(
                icon: Icons.file_download_outlined,
                iconColor: Colors.green,
                title: 'importOPML'.tr,
                subTitle: 'importFeedsFromOPML'.tr,
                onTap: _controller.importOPML,
              ),
              SectionChild(
                icon: Icons.file_upload_outlined,
                iconColor: Colors.greenAccent,
                title: 'exportOPML'.tr,
                subTitle: 'exportFeedsToOPML'.tr,
                onTap: _controller.exportOPML,
              ),
            ],
          )
        ],
      )

          //       // ListTileGroupTitle(title: 'others'.tr),
          //       // ListTile(
          //       //   leading: const Icon(Icons.update_outlined),
          //       //   iconColor: Theme.of(context).textTheme.bodyLarge!.color,
          //       //   title: Text('checkForUpdates'.tr),
          //       //   subtitle: Text('getLatestVersion'.tr),
          //       //   onTap: checkUpdate,
          //       // ),
          //       // ListTile(
          //       //   leading: const Icon(Icons.android_outlined),
          //       //   iconColor: Theme.of(context).textTheme.bodyLarge!.color,
          //       //   title: Text('about'.tr),
          //       //   subtitle: Text('contactAndOpenSource'.tr),
          //       //   onTap: () => Get.to(const AboutPage()),
          //       // ),
          //     ]))
          //   ],

          ),
    );
  }

  Widget _fontWidget() => GetBuilder<GlobalController>(
      builder: (_) => SectionChild(
            icon: Icons.font_download_outlined,
            iconColor: Colors.purple,
            title: 'globalFont'.tr,
            subTitle: cacheThemeFont.split('.').first == '默认字体'
                ? 'defaultFont'.tr
                : cacheThemeFont.split('.').first,
            onTap: () => Get.toNamed(AppRouter.fontSettingPage),
          ));

  Widget _themeWidget() => GetBuilder<GlobalController>(
        id: 'theme',
        builder: (_) => SectionChild(
          icon: Icons.dark_mode,
          iconColor: Get.theme.primaryColor,
          title: 'themeMode'.tr,
          subTitle: [
            'followSystem'.tr,
            'lightMode'.tr,
            'darkMode'.tr
          ][cacheThemeIndex],
          onTap: () => Get.toNamed(AppRouter.themeSettingPageRouter),
        ),
      );

  Widget _languageWidget() => GetBuilder<GlobalController>(
      id: 'language',
      builder: (_) => SectionChild(
          icon: Icons.translate_outlined,
          iconColor: Colors.orange,
          title: 'languageSetting'.tr,
          subTitle: {
                '': 'systemLanguage'.tr,
                'zh': '简体中文',
                'en': 'English',
              }[cacheLaunage] ??
              'systemLanguage'.tr,
          onTap: () => Get.toNamed(AppRouter.languageSettingPageRouter)));

  // 检查更新
  Future<void> checkUpdate() async {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('checkingForUpdates'.tr),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ok'.tr,
          onPressed: () {},
        ),
      ),
    );
    try {
      // 通过访问 https://github.com/gvenusleo/aRead/releases/latest 获取最新版本号
      final Dio dio = Dio();
      final response = await dio.get(
        'https://github.com/gvenusleo/aRead/releases/latest',
      );
      // 获取网页 title
      final String title =
          response.data.split('<title>')[1].split('</title>')[0];
      final String latestVersion = title.split(' ')[1];
      if (latestVersion == applicationVersion) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('alreadyLatestVersion'.tr),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'ok'.tr,
              onPressed: () {},
            ),
          ),
        );
      } else {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text('newVersionAvailable'.tr),
              content: Text('downloadNow'.tr),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr),
                ),
                TextButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse(
                          'https://github.com/gvenusleo/aRead/releases/latest'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text('download'.tr),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('failedToCheckForUpdates'.tr),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'failedToCheckForUpdates'.tr,
            onPressed: () {},
          ),
        ),
      );
    }
  }
}
