import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/com_constant.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/global/global_controller.dart';
import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:flutter_rss_reader/route/app_router.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  // final _controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.medium(title: Text('设置')),
            SliverList.list(
              children: [
                GetBuilder<GlobalController>(
                  builder: (globalController) => ListTile(
                    title: Text('followSystem'.tr),
                    subtitle: Text(
                      ThemeConstant.themeModeDesc[globalController.themeIndex],
                    ),
                    leading: const Icon(Icons.color_lens),
                    onTap: () => Get.toNamed(AppRouter.themeSettingPageRouter),
                  ),
                ),
                GetBuilder<GlobalController>(
                  builder: (globalController) => ListTile(
                    title: Text('languageSetting'.tr),
                    subtitle: Text(
                      LaunageConstant.launages[globalController.launage] ??
                          'systemLanguage'.tr,
                    ),
                    onTap: () =>
                        Get.toNamed(AppRouter.languageSettingPageRouter),
                    leading: const Icon(Icons.language),
                  ),
                ),

                ListTile(
                  title: Text('globalFont'.tr),
                  subtitle: Text(
                    cacheThemeFont.split('.').first == '默认字体'
                        ? 'defaultFont'.tr
                        : cacheThemeFont.split('.').first,
                  ),
                  leading: const Icon(Icons.font_download),
                  onTap: () => Get.toNamed(AppRouter.fontSettingPage),
                ),

                Divider(height: 0.5),

                Padding(
                  padding: EdgeInsetsGeometry.all(18),
                  child: Text('数据管理'),
                ),

                ListTile(
                  title: Text('blockRules'.tr),
                  subtitle: Text('setPostBlockRule'.tr),
                  leading: Icon(Icons.app_blocking_outlined),
                  onTap: () => Get.toNamed(AppRouter.blockSettingPage),
                ),
                ListTile(
                  title: Text('importOPML'.tr),
                  subtitle: Text('importFeedsFromOPML'.tr),
                  leading: Icon(Icons.file_download_outlined),
                  onTap: () => controller.importOPML,
                ),
                ListTile(
                  title: Text('exportOPML'.tr),
                  subtitle: Text('exportFeedsToOPML'.tr),
                  leading: Icon(Icons.file_upload_outlined),
                  onTap: () => controller.exportOPML,
                ),
                Divider(height: 0.5),
                Padding(
                  padding: EdgeInsetsGeometry.all(18),
                  child: Text('意见反馈'),
                ),

                ListTile(
                  title: Text('contactAuthor'.tr),
                  subtitle: Text('lidary@163.com'),
                  leading: Icon(Icons.send),
                  onTap: () async {
                    await launchUrl(
                      Uri(scheme: 'mailto', path: 'lidary@163.com'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
