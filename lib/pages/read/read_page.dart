import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/utils/open_url_util.dart';
import 'package:flutter_rss_reader/widgets/popup_menu_widget.dart';
import 'package:flutter_rss_reader/widgets/status_page.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ReadPage extends StatelessWidget {
  final _controller = Get.put(ReadController());
  ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.rssItem.feedName),
        actions: [
          GetBuilder<ReadController>(
            id: 'popup',
            builder: (_) {
              return PopupMenuButton(
                position: PopupMenuPosition.under,
                itemBuilder: (BuildContext context) => _popupMenu(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Positioned(
          child: GetBuilder<ReadController>(
              id: 'content',
              builder: (_) => StatusPage<String>(
                  contentWidget: (data) => _buildBody(context),
                  status: _controller.pageStatusBean)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GetBuilder<ReadController>(
      id: 'html_widget',
      builder: (_) {
        return HtmlWidget(
          '''
   <div class='aread_html_content'>
    ${_controller.titleStr}
    ${_controller.contentHtml}
    </div>
    ''',
          buildAsync: true,
          rebuildTriggers: RebuildTriggers([
            _controller.textAlign,
            _controller.fontSize,
            _controller.lineHeight,
            _controller.pagePadding,
          ]),
          renderMode: RenderMode.listView,
          onTapImage: (imageMetadata) async {
            final imageUrl = imageMetadata.sources.firstOrNull?.url;
            await _showImageDialog(imageUrl);
          },
          textStyle: TextStyle(
            fontFamily: cacheThemeFont,
            fontSize: _controller.fontSize.toDouble(),
            color: Get.theme.textTheme.bodyLarge!.color!,
          ),
          customStylesBuilder: (element) => buildStyle(context, element),
          onTapUrl: (url) {
            openUrl(url: url);
            return true;
          },
        );
      },
    );
  }

  List<PopupMenuEntry> _popupMenu() => <PopupMenuEntry>[
        // 获取全文
        popupMenuWidget(
            title: 'fullText'.tr,
            icon: Icons.article_outlined,
            onTap: _controller.getHtml),
        // 新标签页中打开
        popupMenuWidget(
            title: 'openInNewTab'.tr,
            icon: Icons.tab_outlined,
            onTap: () => openUrl(url: _controller.rssItem.link, thisApp: true)),
        // 系统浏览器打开
        popupMenuWidget(
            title: 'openInBrowser'.tr,
            icon: Icons.open_in_browser_outlined,
            onTap: () =>
                openUrl(url: _controller.rssItem.link, thisApp: false)),
        const PopupMenuDivider(),

        // 标记为未读
        popupMenuWidget(
            title: 'markAsUnread'.tr,
            icon: _controller.rssItem.read
                ? Icons.radio_button_unchecked
                : Icons.radio_button_checked,
            onTap: _controller.changeReadStatus),

        // 收藏
        popupMenuWidget(
            title: 'collectPost'.tr,
            icon: _controller.rssItem.favorite
                ? Icons.bookmark
                : Icons.bookmark_border_outlined,
            onTap: _controller.changeFavoriteStatus),
        const PopupMenuDivider(),
        // 页面样式
        popupMenuWidget(
            title: 'pageStyle'.tr,
            icon: Icons.line_style_outlined,
            onTap: () => _controller.changeStylePage()),
        const PopupMenuDivider(),
        popupMenuWidget(
            title: 'share'.tr,
            icon: Icons.share_outlined,
            onTap: () => Share.share(
                  _controller.rssItem.link!,
                  subject: _controller.rssItem.title,
                )),
        popupMenuWidget(
            title: 'copyLink'.tr,
            icon: Icons.copy_outlined,
            onTap: () => Clipboard.setData(
                ClipboardData(text: _controller.rssItem.link!))),
      ];

  Future _showImageDialog(String? url) async {
    if (url != null && url.isEmpty == false) {
      await Get.dialog(
          Stack(
            children: [
              PhotoView(
                onTapDown: (context, details, controllerValue) => Get.back(),
                imageProvider: CachedNetworkImageProvider(url),
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
    }
  }

  Map<String, String>? buildStyle(BuildContext context, dom.Element element) {
    if (element.className == 'aread_html_content') {
      return {
        'line-height': '${_controller.lineHeight}',
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
    }
    return null;
  }
}
