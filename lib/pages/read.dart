import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_main_element/html_main_element.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:flutter_rss_reader/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({
    super.key,
    required this.post,
    required this.fullText,
    required this.fontDir,
  });
  final Post post;
  final bool fullText;
  final String fontDir;

  @override
  ReadPageState createState() => ReadPageState();
}

class ReadPageState extends State<ReadPage> {
  int _index = 0; // 堆叠索引
  String contentHtml = ''; // 内容 html

  // 根据 url 获取 html 内容
  Future<void> initData(String url) async {
    if (widget.fullText && widget.post.read != 2 && widget.post.openType == 0) {
      setState(() {
        _index = 0;
      });
      final response = await Dio().get(url);
      final document = html_parser.parse(response.data);
      final bestElemReadability =
          readabilityMainElement(document.documentElement!);
      widget.post.content = bestElemReadability.outerHtml;
      widget.post.read = 2;
      widget.post.updateToDb();
      setState(() {
        contentHtml = widget.post.content;
        _index = 1;
      });
    } else {
      setState(() {
        contentHtml = widget.post.content;
        _index = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initData(widget.post.link);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final String textColor = themeData.textTheme.bodyLarge!.color!.value
        .toRadixString(16)
        .substring(2);
    final String backgroundColor =
        themeData.scaffoldBackgroundColor.value.toRadixString(16).substring(2);
    final titleStr = '<h1>${widget.post.title}</h1>';
    final String cssStr = '''
@font-face {
  font-family: 'customFont';
  src: url('${widget.fontDir}/${context.watch<ThemeProvider>().themeFont}');
}
body {
  font-family: 'customFont';
  font-size: ${context.watch<ReadPageProvider>().fontSize}px;
  line-height: ${context.watch<ReadPageProvider>().lineHeight};
  color: #$textColor;
  background-color: #$backgroundColor;
  width: auto;
  height: auto;
  margin: 0;
  word-wrap: break-word;
  padding: 12px ${context.watch<ReadPageProvider>().pagePadding}px !important;
  text-align: ${context.watch<ReadPageProvider>().textAlign};
}
h1 {
  font-size: 1.5em;
  font-weight: 700;
}
h2 {
  font-size: 1.25em;
  font-weight: 700;
}
h3,h4,h5,h6 {
  font-size: 1.0em;
  font-weight: 700;
}
img,figure,video,iframe {
  max-width: 100% !important;
  height: auto;
  margin: 0 auto;
  display: block;
}

a {
  color: #$textColor;
  text-decoration: none;
  border-bottom: 1px solid #$textColor;
  padding-bottom: 1px;
  word-break: break-all;
}
blockquote {
  margin: 0;
  padding: 0 0 0 16px;
  border-left: 4px solid #9e9e9e;
}
pre {
  white-space: pre-wrap;
  word-break: break-all;
}
table {
  width: 100% !important;
  table-layout: fixed;
}
table td {
  padding: 0 8px;
}

table, th, td {
  border: 1px solid #$textColor;
  border-collapse: collapse;
}
${context.watch<ReadPageProvider>().customCss}
''';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.feedName),
        actions: [
          IconButton(
            onPressed: () async {
              await launchUrl(
                Uri.parse(widget.post.link),
                mode: LaunchMode.externalApplication,
              );
            },
            icon: const Icon(Icons.open_in_browser_outlined),
          ),
          IconButton(
            onPressed: () {
              Share.share(
                widget.post.link,
                subject: widget.post.title,
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
                    await widget.post.markUnread();
                  },
                  child: Text(
                    "markAsUnread".tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    widget.post.favorite = widget.post.favorite == 0 ? 1 : 0;
                    await widget.post.changeFavorite();
                  },
                  child: Text(
                    widget.post.favorite == 1
                        ? 'cancelCollect'.tr
                        : 'collectPost'.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.post.link));
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
    if (_index == 0) {
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
      initialData: widget.post.openType == 0
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
$contentHtml
</body>
</html>
''',
              baseUrl: Uri.directory(widget.fontDir),
            )
          : null,
      initialUrlRequest: widget.post.openType != 0
          ? URLRequest(
              url: Uri.parse(
                widget.post.link.replaceFirst(RegExp(r'^http://'), 'https://'),
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
