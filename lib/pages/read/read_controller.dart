import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_main_element/html_main_element.dart';

class ReadController extends GetxController {
  InAppWebViewController? _webViewController;

  final Post post = Get.arguments[parametersPost];
  final bool fullText = Get.arguments[parametersFullText];
  final String fontDir = Get.arguments[parametersFontDir];

  int fontSize = prefs.getInt('fontSize') ?? 18;
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  String textAlign = prefs.getString('textAlign') ?? 'justify';
  String customCss = prefs.getString('customCss') ?? '';

  String _cssStr = '';
  String get cssStr => _cssStr;
  String _titleStr = '';
  String get titleStr => _titleStr;
  @override
  void onInit() {
    _titleStr = '<h1>${post.title}</h1>';
    createCss();
    super.onInit();
  }

  String? _contentHtml; // 内容 html
  String? get contentHtml => _contentHtml;
  // 根据 url 获取 html 内容
  Future<void> initData(String url) async {
    if (fullText && post.read != 2 && post.openType == 0) {
      final response = await Dio().get(url);
      final document = html_parser.parse(response.data);
      final bestElemReadability =
          readabilityMainElement(document.documentElement!);
      post.content = bestElemReadability.outerHtml;
      post.read = 2;
      post.updateToDb();
    }
    _contentHtml = post.content;
    update(['content']);
    _changeStyle = false;
  }

  @override
  void onReady() {
    super.onReady();
    initData(post.link);
  }

  void createCss() {
    final String textColor = Get.theme.textTheme.bodyLarge!.color!.value
        .toRadixString(16)
        .substring(2);
    final String backgroundColor =
        Get.theme.scaffoldBackgroundColor.value.toRadixString(16).substring(2);
    _cssStr = '''
@font-face {
  font-family: 'customFont';
  src: url('$fontDir/$cacheThemeFont');
}
body {
  font-family: 'customFont';
  font-size: ${fontSize}px;
  line-height: $lineHeight;
  color: #$textColor;
  background-color: #$backgroundColor;
  width: auto;
  height: auto;
  margin: 0;
  word-wrap: break-word;
  padding: 12px ${pagePadding}px !important;
  text-align: $textAlign;
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
$customCss
''';
  }

  void changeStylePage() {
    Get.toNamed(AppRouter.readSettingPage)?.then((value) {
      if (_changeStyle) {
        createCss();
        _webViewController?.injectCSSCode(source: cssStr);
      }
    });
  }

  void setWebViewController(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }

  /// 阅读页面样式相关设置
  bool _changeStyle = false;

  Future<void> changeFontSize(int? size) async {
    if (size == null || size == fontSize) {
      return;
    }
    await prefs.setInt('fontSize', size);
    fontSize = size;
    _changeStyle = true;
    update(['font_size']);
  }

  Future<void> changeLineHeight(double? height) async {
    if (height == null || height == lineHeight) {
      return;
    }
    await prefs.setDouble('lineheight', height);
    lineHeight = height;
    _changeStyle = true;
    update(['line_height']);
  }

  Future<void> changePagePadding(int? padding) async {
    if (padding == null || padding == pagePadding) {
      return;
    }
    await prefs.setInt('pagePadding', padding);
    pagePadding = padding;
    _changeStyle = true;
    update(['page_padding']);
  }

  Future<void> changeTextAlign(String? align) async {
    if (align == null || align == textAlign) {
      return;
    }
    await prefs.setString('textAlign', align);
    textAlign = align;
    _changeStyle = true;
    update(['text_alignment']);
  }

  Future<void> changeCustomCss(String? css) async {
    if (css == null || css.isBlank == true || css == customCss) {
      return;
    }
    await prefs.setString('customCss', css);
    customCss = css;
    _changeStyle = true;
    update(['custom_css']);
  }

  static const String parametersPost = 'post';
  static const String parametersFullText = 'full_text';
  static const String parametersFontDir = 'font_dir';
}
