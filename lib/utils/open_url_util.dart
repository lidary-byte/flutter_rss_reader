import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/route/app_router.dart';
import 'package:flutter_rss_reader/pages/web_view/web_view_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// 使用 [InAppBrowser] 打开一个 url
/// [thisApp] 是否在当前应用内打开
void openUrl({String? url, bool thisApp = true}) {
  if (url == null) {
    return;
  }
  if (thisApp) {
    Get.toNamed(
      AppRouter.webViewPageRouter,
      arguments: {WebViewController.parametersUrl: url},
    );
  } else {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
