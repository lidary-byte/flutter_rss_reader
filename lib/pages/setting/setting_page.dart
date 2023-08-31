import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/pages/setting/about_page/about_page.dart';
import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:flutter_rss_reader/utils/parse.dart';
import 'package:flutter_rss_reader/widgets/list_tile_group_title.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final _controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
            title: Text(
          'settings'.tr,
        )),
        SliverList(
            delegate: SliverChildListDelegate([
          ListTileGroupTitle(
            title: 'personalization'.tr,
          ),
          _languageWidget(),
          _themeWidget(),
          _dynamicWidget(),
          _fontWidget(),
          _scaleWidget(),
          ListTileGroupTitle(title: 'dataManagement'.tr),
          ListTile(
            leading: const Icon(Icons.app_blocking_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: Text('blockRules'.tr),
            subtitle: Text('setPostBlockRule'.tr),
            onTap: () => Get.toNamed(AppRouter.blockSettingPage),
          ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: Text('importOPML'.tr),
            subtitle: Text('importFeedsFromOPML'.tr),
            onTap: importOPML,
          ),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: Text('exportOPML'.tr),
            subtitle: Text('exportFeedsToOPML'.tr),
            onTap: exportOPML,
          ),
          ListTileGroupTitle(title: 'others'.tr),
          ListTile(
            leading: const Icon(Icons.update_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: Text('checkForUpdates'.tr),
            subtitle: Text('getLatestVersion'.tr),
            onTap: checkUpdate,
          ),
          ListTile(
            leading: const Icon(Icons.android_outlined),
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            title: Text('about'.tr),
            subtitle: Text('contactAndOpenSource'.tr),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return const AboutPage();
              }));
            },
          ),
        ]))
      ],
    );
  }

  Widget _scaleWidget() => GetBuilder<GlobalController>(
      builder: (_) => ListTile(
            leading: const Icon(Icons.text_fields_outlined),
            iconColor: Get.theme.textTheme.bodyLarge!.color,
            title: Text('globalScale'.tr),
            subtitle: Text(
              {
                    0.8: 'minimum'.tr,
                    0.9: 'small'.tr,
                    1.0: 'medium'.tr,
                    1.1: 'large'.tr,
                    1.2: 'maximum'.tr,
                  }[cacheTextScaleFactor] ??
                  'medium'.tr,
            ),
            onTap: () => Get.toNamed(AppRouter.textScaleFactorSettingPage),
          ));

  Widget _fontWidget() => GetBuilder<GlobalController>(
      id: 'font',
      builder: (_) => ListTile(
            leading: const Icon(Icons.font_download_outlined),
            iconColor: Get.theme.textTheme.bodyLarge!.color,
            title: Text('globalFont'.tr),
            subtitle: Text(
              cacheThemeFont.split('.').first == '默认字体'
                  ? 'defaultFont'.tr
                  : cacheThemeFont.split('.').first,
            ),
            onTap: () => Get.toNamed(AppRouter.fontSettingPage),
          ));
  Widget _dynamicWidget() => GetBuilder<GlobalController>(
      builder: (_) => ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            iconColor: Get.theme.textTheme.bodyLarge!.color,
            title: Text('dynamicColor'.tr),
            subtitle: Text(cacheDynamicColor ? 'open'.tr : 'close'.tr),
            onTap: () => Get.toNamed(AppRouter.dynamicColorSettingPage),
          ));

  Widget _themeWidget() => GetBuilder<GlobalController>(
        id: 'theme',
        builder: (_) => ListTile(
          leading: const Icon(Icons.dark_mode_outlined),
          iconColor: Get.theme.textTheme.bodyLarge!.color,
          title: Text('themeMode'.tr),
          subtitle: Text(
            ['followSystem'.tr, 'lightMode'.tr, 'darkMode'.tr][cacheThemeIndex],
          ),
          onTap: () => Get.toNamed(AppRouter.themeSettingPageRouter),
        ),
      );

  Widget _languageWidget() => GetBuilder<GlobalController>(
      id: 'language',
      builder: (_) => ListTile(
          leading: const Icon(Icons.translate_outlined),
          iconColor: Get.theme.textTheme.bodyLarge!.color,
          title: Text('languageSetting'.tr),
          subtitle: Text(
            {
                  '': 'systemLanguage'.tr,
                  'zh': '简体中文',
                  'en': 'English',
                }[cacheLaunage] ??
                'systemLanguage'.tr,
          ),
          onTap: () => Get.toNamed(AppRouter.languageSettingPageRouter)));

  // 导入 OPML 文件
  Future<void> importOPML() async {
    // 打开文件选择器
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['opml', 'xml'],
    );
    if (result != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('startBackgroundImport'.tr),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'ok'.tr,
            onPressed: () {},
          ),
        ),
      );
      final int failCount = await parseOpml(result);

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            failCount == 0
                ? 'importSuccess'.tr
                : 'importFailedForFeeds(failCount)'.tr,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'ok'.tr,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  // 导出 OPML 文件
  Future<void> exportOPML() async {
    final String successText = 'shareOPMLFile'.tr;
    String opmlStr = await exportOpml();
    // opmlStr 字符串写入 feeds.opml 文件并分享，分享后删除文件
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/feeds-from-MeReader.xml');
    await file.writeAsString(opmlStr);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: successText,
    ).then((value) {
      if (value.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('exportSuccess'.tr),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(label: 'ok'.tr, onPressed: () {}),
          ),
        );
      }
    });
    await file.delete();
  }

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
      // 通过访问 https://github.com/gvenusleo/MeRead/releases/latest 获取最新版本号
      final Dio dio = Dio();
      final response = await dio.get(
        'https://github.com/gvenusleo/MeRead/releases/latest',
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
                          'https://github.com/gvenusleo/MeRead/releases/latest'),
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