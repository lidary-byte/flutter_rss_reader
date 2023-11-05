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
          ),
          ListSectionGroup(
            titleText: 'feedback'.tr,
            children: [
              SectionChild(
                icon: Icons.send_outlined,
                iconColor: Colors.blue,
                title: 'contactAuthor'.tr,
                subTitle: 'lidary@163.com',
                onTap: () async {
                  await launchUrl(
                      Uri(scheme: 'mailto', path: 'lidary@163.com'));
                },
              ),
            ],
          )
        ],
      )),
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
          iconColor: Colors.blue,
          title: 'languageSetting'.tr,
          subTitle: {
                '': 'systemLanguage'.tr,
                'zh': '简体中文',
                'en': 'English',
              }[cacheLaunage] ??
              'systemLanguage'.tr,
          onTap: () => Get.toNamed(AppRouter.languageSettingPageRouter)));
}
