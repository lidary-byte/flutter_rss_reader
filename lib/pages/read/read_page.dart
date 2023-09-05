import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/theme/custom_theme.dart';
import 'package:flutter_rss_reader/utils/open_url_util.dart';
import 'package:flutter_rss_reader/widgets/popup_menu_widget.dart';
import 'package:flutter_rss_reader/widgets/status_page.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReadPage extends StatelessWidget {
  final _controller = Get.put(ReadController());
  ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_controller.post.feedName),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => _popupMenu(),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: GetBuilder<ReadController>(
                  id: 'content',
                  builder: (_) => StatusPage<String>(
                      contentWidget: (data) => _buildBody(),
                      status: _controller.pageStatusBean)),
            ),
            Positioned(bottom: 20, left: 14, right: 14, child: _bottomBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Listener(
      onPointerDown: (event) =>
          _controller.setMoveXY(event.position.dx, event.position.dy),
      onPointerMove: (event) =>
          _controller.moveXY(event.position.dx, event.position.dy),
      onPointerUp: (event) =>
          _controller.reSetMoveXY(event.position.dx, event.position.dy),
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <style>
    ${_controller.css}
    </style>
    </head>
    <body>
    ${_controller.titleStr}
    ${_controller.contentHtml}
    </body>
    </html>
    ''',
          baseUrl: Uri.directory(_controller.fontDir),
        ),
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          crossPlatform: InAppWebViewOptions(
            transparentBackground: true,
            useShouldOverrideUrlLoading: true,
          ),
        ),
        /* 点击链接时使用内置标签页打开 */
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final url = navigationAction.request.url.toString();
          if (url.startsWith('http://') || url.startsWith('https://')) {
            openUrl(url);
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onWebViewCreated: _controller.setWebViewController,
      ),
    );
  }

  List<PopupMenuEntry> _popupMenu() => <PopupMenuEntry>[
        popupMenuWidget(
            title: 'openInNewTab'.tr,
            icon: Icons.tab_outlined,
            onTap: () => openUrl(_controller.post.link, thisApp: true)),
        popupMenuWidget(
            title: 'openInBrowser'.tr,
            icon: Icons.open_in_browser_outlined,
            onTap: () => openUrl(_controller.post.link, thisApp: false)),
        const PopupMenuDivider(),
        popupMenuWidget(
            title: 'share'.tr,
            icon: Icons.share_outlined,
            onTap: () => Share.share(
                  _controller.post.link,
                  subject: _controller.post.title,
                )),
        popupMenuWidget(
            title: 'copyLink'.tr,
            icon: Icons.copy_outlined,
            onTap: () =>
                Clipboard.setData(ClipboardData(text: _controller.post.link))),
      ];

  Widget _bottomBar() => GetBuilder<ReadController>(
      id: 'bottom',
      builder: (_) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            ),
            child: _controller.isBottomOpen
                ? Container(
                    decoration: BoxDecoration(
                      color: Get.theme
                          .extension<CustomTheme>()!
                          .bottomNavigationBarBackgroundColor, // 背景颜色
                      borderRadius: BorderRadius.circular(10.0), // 圆角半径
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () =>
                                Get.toNamed(AppRouter.readSettingPage),
                            icon: Icon(
                              Icons.font_download_outlined,
                              color: Get.theme
                                  .extension<CustomTheme>()!
                                  .activeNavigationBarColor,
                            )),
                        // 标记未读
                        GetBuilder<ReadController>(
                            id: 'read_status',
                            builder: (_) => IconButton(
                                onPressed: _controller.changeReadStatus,
                                icon: Icon(
                                    _controller.post.read
                                        ? Icons.radio_button_unchecked
                                        : Icons.radio_button_checked,
                                    color: Get.theme
                                        .extension<CustomTheme>()!
                                        .activeNavigationBarColor))),
                        //收藏文章
                        GetBuilder<ReadController>(
                            id: 'favorite',
                            builder: (_) => IconButton(
                                onPressed: _controller.changeFavoriteStatus,
                                icon: Icon(
                                    _controller.post.favorite
                                        ? Icons.bookmark
                                        : Icons.bookmark_border_outlined,
                                    color: Get.theme
                                        .extension<CustomTheme>()!
                                        .activeNavigationBarColor))),
                        GetBuilder<ReadController>(
                            id: 'html_cache',
                            builder: (_) => IconButton(
                                onPressed: _controller.post.fullTextCache
                                    ? null
                                    : _controller.getHtml,
                                icon: Icon(Icons.article_outlined,
                                    color: Get.theme
                                        .extension<CustomTheme>()!
                                        .activeNavigationBarColor))),
                      ],
                    ),
                  )
                : null,
          ));

  // Widget _bottomStyleWidget() {
  //   return Container(
  //       height: 200,
  //       child: ListView(
  //         padding: const EdgeInsets.all(6.0),
  //         children: [
  //           FontSizeWidget(),
  //           // ListTile(
  //           //   iconColor: Get.theme.colorScheme.onPrimary,
  //           //   title: Text('fontSize'.tr),
  //           //   subtitle: Text(
  //           //     {
  //           //           14: 'minimum'.tr,
  //           //           16: 'small'.tr,
  //           //           18: 'medium'.tr,
  //           //           20: 'large'.tr,
  //           //           22: 'maximum'.tr,
  //           //         }[_controller.fontSize] ??
  //           //         'medium'.tr,
  //           //   ),
  //           // )),
  //           Row(
  //             children: [
  //               Text('字体大小'),
  //               Text('行高'),
  //               Text('页面边距'),
  //               Text('文本对齐'),
  //               Text('自定义css'),
  //             ],
  //           )
  //         ],
  //       ));
  // }
}
