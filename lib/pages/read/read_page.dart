import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/utils/open_url_util.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadPage extends StatelessWidget {
  ReadPage({super.key});

  final _controller = Get.put(ReadController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.post.feedName),
        actions: [
          IconButton(
            onPressed: () async {
              await launchUrl(
                Uri.parse(_controller.post.link),
                mode: LaunchMode.externalApplication,
              );
            },
            icon: const Icon(Icons.open_in_browser_outlined),
          ),
          IconButton(
            onPressed: () {
              Share.share(
                _controller.post.link,
                subject: _controller.post.title,
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => _popupMenu(),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: GetBuilder<ReadController>(
              id: 'content',
              builder: (_) => _controller.contentHtml == null
                  ? _loadingWidget()
                  : _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    String html = '''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
${_controller.customCss}
</style>
</head>
<body>
${_controller.titleStr}
${_controller.contentHtml}
</body>
''';
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: _controller.pagePadding.toDouble(),
      ),
      child: Html(
        data: html,
        style: _controller.cssMap,
        onLinkTap: (url, attributes, element) {
          if (url != null) {
            openUrl(url);
          }
        },
        extensions: [
          OnImageTapExtension(
            onImageTap: (url, attributes, element) {
              if (url != null) {
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return AlertDialog(
                //       icon: const Icon(Icons.image_outlined),
                //       title: Text(AppLocalizations.of(context)!.saveImage),
                //       content: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Image.network(url),
                //           const SizedBox(height: 12),
                //           Text(AppLocalizations.of(context)!.saveImageInfo),
                //         ],
                //       ),
                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           child: Text(AppLocalizations.of(context)!.cancel),
                //         ),
                //         TextButton(
                //           onPressed: () async {
                //             var response = await Dio().get(
                //               url,
                //               options: Options(
                //                 responseType: ResponseType.bytes,
                //               ),
                //             );
                //             final result = await ImageGallerySaver.saveImage(
                //               Uint8List.fromList(response.data),
                //               quality: 80,
                //               name: attributes['alt'] ?? 'image',
                //             );
                //             if (result['isSuccess']) {
                //               if (!mounted) return;
                //               Fluttertoast.showToast(
                //                 msg: AppLocalizations.of(context)!
                //                     .saveImageSuccess,
                //               );
                //             }
                //             if (!mounted) return;
                //             Navigator.of(context).pop();
                //           },
                //           child: Text(AppLocalizations.of(context)!.ok),
                //         ),
                //       ],
                //     );
                //   },
                // );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _loadingWidget() => Center(
      child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
              ),
              const SizedBox(height: 12),
              Text('gettingFullText'.tr),
            ],
          )));

  List<PopupMenuEntry> _popupMenu() => <PopupMenuEntry>[
        //只有当设置了在应用内打开才支持设置样式
        if (_controller.post.openType == 0)
          PopupMenuItem(
            onTap: _controller.changeStylePage,
            child: Text(
              "customPostReadingPage".tr,
              style: Get.theme.textTheme.bodyMedium,
            ),
          ),
        PopupMenuItem(
          onTap: () => _controller.post.markAsUnread(),
          child: Text(
            "markAsUnread".tr,
            style: Get.theme.textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          onTap: () async => await _controller.post.changeFavorite(),
          child: Text(
            _controller.post.favorite ? 'cancelCollect'.tr : 'collectPost'.tr,
            style: Get.theme.textTheme.bodyMedium,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () =>
              Clipboard.setData(ClipboardData(text: _controller.post.link)),
          child: Text(
            'copyLink'.tr,
            style: Get.theme.textTheme.bodyMedium,
          ),
        ),
      ];
}
