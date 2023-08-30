import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/provider/theme_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () async {
                    await _controller.post.markUnread();
                  },
                  child: Text(
                    "markAsUnread".tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    _controller.post.favorite =
                        _controller.post.favorite == 0 ? 1 : 0;
                    await _controller.post.changeFavorite();
                  },
                  child: Text(
                    _controller.post.favorite == 1
                        ? 'cancelCollect'.tr
                        : 'collectPost'.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: _controller.post.link));
                  },
                  child: Text(
                    'copyLink'.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: _buildBody(cssStr, titleStr),
        ),
      ),
    );
  }

  Widget _buildBody(String cssStr, String titleStr) {
    if (_controller.index == 0) {
      return Center(
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
          ),
        ),
      );
    }
    return InAppWebView(
      initialData: _controller.post.openType == 0
          ? InAppWebViewInitialData(
              data: '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
$cssStr
</style>
</head>
<body>
$titleStr
${_controller.contentHtml}
</body>
</html>
''',
              baseUrl: Uri.directory(_controller.fontDir),
            )
          : null,
      initialUrlRequest: _controller.post.openType != 0
          ? URLRequest(
              url: Uri.parse(
                _controller.post.link
                    .replaceFirst(RegExp(r'^http://'), 'https://'),
              ),
            )
          : null,
      initialOptions: InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        crossPlatform: InAppWebViewOptions(
          transparentBackground: true,
        ),
      ),
    );
  }
}
