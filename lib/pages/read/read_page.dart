import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/theme/custom_bottom_nav_theme.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:flutter_rss_reader/utils/open_url_util.dart';
import 'package:flutter_rss_reader/widgets/popup_menu_widget.dart';
import 'package:flutter_rss_reader/widgets/status_page.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ReadPage extends StatelessWidget {
  final _controller = Get.put(ReadController());
  ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: HtmlWidget(
        '''
   <div class='aread_html_content'>
    ${_controller.titleStr}
    ${_controller.contentHtml}
    </div>
    ''',
        renderMode: RenderMode.listView,
        onTapImage: (imageMetadata) {
          final imageUrl = imageMetadata.sources.firstOrNull?.url;
          if (imageUrl != null) {
            Get.dialog(
                Stack(
                  children: [
                    PhotoView(
                      onTapDown: (context, details, controllerValue) =>
                          Get.back(),
                      imageProvider: CachedNetworkImageProvider(imageUrl),
                    ),
                    Positioned(
                        right: 10,
                        top: 50,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close_outlined),
                          color: Colors.white,
                        )),
                  ],
                ),
                useSafeArea: false);
            // showImageViewer(Get.context!, CachedNetworkImageProvider(imageUrl),
            //     doubleTapZoomable: true, backgroundColor: HexColor('#000000'));
          }
        },
        textStyle:
            TextStyle(fontFamily: '${_controller.fontDir}/$cacheThemeFont'),
        customStylesBuilder: (element) {
          if (element.className == 'aread_html_content') {
            return {
              'font-family': 'customFont',
              'font-size': '${_controller.fontSize}px',
              'line-height': '${_controller.lineHeight}',
              'color':
                  '#${Get.theme.textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
              'background-color':
                  '#${Get.theme.scaffoldBackgroundColor.value.toRadixString(16).substring(2)}',
              'width': 'auto',
              'height': 'auto',
              'margin': '0',
              'word-wrap': 'break-word',
              'padding': '12px ${_controller.pagePadding}px !important',
              'text-align': _controller.textAlign
            };
          }
          switch (element.localName) {
            case 'h1':
              return {'font-size': '1.5em', 'font-weight': '700'};
            case 'h2':
              return {'font-size': '1.25em', 'font-weight': '700'};
            case 'h3':
            case 'h4':
            case 'h5':
            case 'h6':
              return {'font-size': '1.0em', 'font-weight': '700'};
            case 'img':
            case 'figure':
            case 'video':
            case 'iframe':
              return {
                'max-width': '100% !important',
                'height': 'auto',
                'margin': '0 auto',
                'display': 'block',
              };
            case 'body':
              return {
                'font-family': 'customFont',
                'font-size': '${_controller.fontSize}px',
                'line-height': '${_controller.lineHeight}',
                'color':
                    '#${Get.theme.textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
                'background-color':
                    '#${Get.theme.scaffoldBackgroundColor.value.toRadixString(16).substring(2)}',
                'width': 'auto',
                'height': 'auto',
                'margin': '0',
                'word-wrap': 'break-word',
                'padding': '12px ${_controller.pagePadding}px !important',
                'text-align': _controller.textAlign
              };
            case 'a':
              return {
                'color':
                    '#${Get.theme.colorScheme.primary.value.toRadixString(16).substring(2)}',
                'text-decoration': 'none',
                'border-bottom':
                    '1px solid #${Get.theme.colorScheme.primary.value.toRadixString(16).substring(2)}',
                'padding-bottom': '1px',
                'word-break': 'break-all'
              };

            case 'blockquote':
              return {
                'margin': '0',
                'padding': '0 0 0 16px',
                'border-left': '4px solid #9e9e9e'
              };
            case 'pre':
              return {'white-space': 'pre-wrap', 'word-break': 'break-all'};

            case 'table':
              return {
                'width': '100% !important',
                'table-layout': 'fixed',
                'border':
                    '1px solid #${Get.theme.textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
                'border-collapse': 'collapse',
                'padding': '0 8px'
              };
            case 'td':
              return {
                'padding': '0 8px',
                'border':
                    '1px solid #${Get.theme.textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
                'border-collapse': 'collapse'
              };
            case 'th':
              return {
                'border':
                    '1px solid #${Get.theme.textTheme.bodyLarge!.color!.value.toRadixString(16).substring(2)}',
                'border-collapse': 'collapse'
              };
            default:
              debugPrint('------------style:${element.localName}');
          }
          return null;
        },
        onTapUrl: (url) {
          openUrl(url: url);
          return true;
        },
        // initialOptions: InAppWebViewGroupOptions(
        //   android: AndroidInAppWebViewOptions(
        //     useHybridComposition: true,
        //   ),
        //   crossPlatform: InAppWebViewOptions(
        //     transparentBackground: true,
        //     useShouldOverrideUrlLoading: true,
        //   ),
        // ),
        // /* 点击链接时使用内置标签页打开 */
        // shouldOverrideUrlLoading: (controller, navigationAction) async {
        //   final url = navigationAction.request.url.toString();
        //   if (url.startsWith('http://') || url.startsWith('https://')) {
        //     openUrl(url: url);
        //     return NavigationActionPolicy.CANCEL;
        //   }
        //   return NavigationActionPolicy.ALLOW;
        // },
        // onWebViewCreated: _controller.setWebViewController,
      ),
    );
  }

  // Widget _buildBody() {
  //   return Listener(
  //     onPointerDown: (event) =>
  //         _controller.setMoveXY(event.position.dx, event.position.dy),
  //     onPointerMove: (event) =>
  //         _controller.moveXY(event.position.dx, event.position.dy),
  //     onPointerUp: (event) =>
  //         _controller.reSetMoveXY(event.position.dx, event.position.dy),
  //     child: InAppWebView(
  //       initialData: InAppWebViewInitialData(
  //         data: '''
  //   <!DOCTYPE html>
  //   <html>
  //   <head>
  //   <meta charset="utf-8">
  //   <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  //   <style>
  //   ${_controller.css}
  //   </style>
  //   </head>
  //   <body>
  //   ${_controller.titleStr}
  //   ${_controller.contentHtml}
  //   </body>
  //   </html>
  //   ''',
  //         baseUrl: Uri.directory(_controller.fontDir),
  //       ),
  //       initialOptions: InAppWebViewGroupOptions(
  //         android: AndroidInAppWebViewOptions(
  //           useHybridComposition: true,
  //         ),
  //         crossPlatform: InAppWebViewOptions(
  //           transparentBackground: true,
  //           useShouldOverrideUrlLoading: true,
  //         ),
  //       ),
  //       /* 点击链接时使用内置标签页打开 */
  //       shouldOverrideUrlLoading: (controller, navigationAction) async {
  //         final url = navigationAction.request.url.toString();
  //         if (url.startsWith('http://') || url.startsWith('https://')) {
  //           openUrl(url: url);
  //           return NavigationActionPolicy.CANCEL;
  //         }
  //         return NavigationActionPolicy.ALLOW;
  //       },
  //       onWebViewCreated: _controller.setWebViewController,
  //     ),
  //   );
  // }

  List<PopupMenuEntry> _popupMenu() => <PopupMenuEntry>[
        popupMenuWidget(
            title: 'openInNewTab'.tr,
            icon: Icons.tab_outlined,
            onTap: () => openUrl(url: _controller.post.link, thisApp: true)),
        popupMenuWidget(
            title: 'openInBrowser'.tr,
            icon: Icons.open_in_browser_outlined,
            onTap: () => openUrl(url: _controller.post.link, thisApp: false)),
        const PopupMenuDivider(),
        popupMenuWidget(
            title: 'share'.tr,
            icon: Icons.share_outlined,
            onTap: () => Share.share(
                  _controller.post.link!,
                  subject: _controller.post.title,
                )),
        popupMenuWidget(
            title: 'copyLink'.tr,
            icon: Icons.copy_outlined,
            onTap: () =>
                Clipboard.setData(ClipboardData(text: _controller.post.link!))),
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
                          .extension<CustomBottomNavTheme>()!
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
                              color: Get.theme.primaryColor,
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
                                    color: Get.theme.primaryColor))),
                        //收藏文章
                        GetBuilder<ReadController>(
                            id: 'favorite',
                            builder: (_) => IconButton(
                                onPressed: _controller.changeFavoriteStatus,
                                icon: Icon(
                                    _controller.post.favorite
                                        ? Icons.bookmark
                                        : Icons.bookmark_border_outlined,
                                    color: Get.theme.primaryColor))),
                        GetBuilder<ReadController>(
                            id: 'html_cache',
                            builder: (_) => IconButton(
                                onPressed: _controller.getHtml,
                                icon: Icon(Icons.article_outlined,
                                    color: Get.theme.primaryColor))),
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
