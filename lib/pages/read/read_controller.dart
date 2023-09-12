import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/base/api_provider.dart';
import 'package:flutter_rss_reader/base/base_status_controller.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_main_element/html_main_element.dart';

class ReadController extends BaseGetxController {
  final CancelToken _cancelToken = CancelToken();

  bool _isBottomOpen = true;
  bool get isBottomOpen => _isBottomOpen;

  InAppWebViewController? _webViewController;

  RssItemBean post = Get.arguments[parametersPost];
  String fontDir = Get.arguments[parametersFontDir];

  int fontSize = prefs.getInt('fontSize') ?? 18;
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  String textAlign = prefs.getString('textAlign') ?? 'justify';
  String customCss = prefs.getString('customCss') ?? '';

  String _css = '';
  String get css => _css;
  String _titleStr = '';
  String get titleStr => _titleStr;

  String? _contentHtml; // 内容 html
  String? get contentHtml => _contentHtml;
  // 根据 url 获取 html 内容
  void _initData() async {
    if (post.fullText && post.cacheContent == null && post.openType == 0) {
      getHtml();
    } else {
      _contentHtml = post.description;
      updateSuccessStatus(contentHtml, updateIds: ['content', 'html_cache']);
      _changeStyle = false;
      if (!post.read) {
        post.read = true;
      }
      post.updateToDb();
    }
  }

  void getHtml() async {
    updateLoadingStatus(updateIds: ['content']);
    final response =
        await ApiProvider().dio.get(post.link!, cancelToken: _cancelToken);
    final document = html_parser.parse(response.data);
    final bestElemReadability =
        readabilityMainElement(document.documentElement!);
    post.cacheContent = bestElemReadability.outerHtml;

    _contentHtml = post.cacheContent;
    updateSuccessStatus(contentHtml, updateIds: ['content', 'html_cache']);
    _changeStyle = false;
    if (!post.read) {
      post.read = true;
    }
    post.updateToDb();
  }

  @override
  void onReady() {
    super.onReady();
    _titleStr = '<h1>${post.title}</h1>';
    _createCss();
    _initData();
  }

  void changeStylePage() {
    Get.toNamed(AppRouter.readSettingPage)?.then((value) {
      if (_changeStyle) {
        _createCss();
        _webViewController?.injectCSSCode(source: _css);
      }
    });
  }

  void setWebViewController(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }

  void _createCss() {
    final String textColor = Get.theme.textTheme.bodyLarge!.color!.value
        .toRadixString(16)
        .substring(2);
    final String backgroundColor =
        Get.theme.scaffoldBackgroundColor.value.toRadixString(16).substring(2);
    final String themeColor =
        Get.theme.colorScheme.primary.value.toRadixString(16).substring(2);

    _css = '''
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
  color: #$themeColor;
  text-decoration: none;
  border-bottom: 1px solid #$themeColor;
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

  double _moveLastX = 0;
  double _moveLastY = 0;

  void setMoveXY(double x, double y) {
    if (_moveLastX == 0 && _moveLastY == 0) {
      _moveLastX = x;
      _moveLastY = y;
    }
  }

  void moveXY(double x, double y) {
    if (_isBottomOpen &&
        (x - _moveLastX).abs() > 10 &&
        (y - _moveLastY).abs() > 10) {
      bottomWidgetClose();
    }
  }

  void reSetMoveXY(double x, double y) {
    if ((x - _moveLastX).abs() < 5 && (y - _moveLastY).abs() < 5) {
      bottomOpenStatus();
    }
    _moveLastX = 0;
    _moveLastY = 0;
  }

  void bottomOpenStatus() {
    _isBottomOpen = !_isBottomOpen;
    update(['bottom']);
  }

  void bottomWidgetClose() {
    if (_isBottomOpen) {
      _isBottomOpen = false;
      update(['bottom']);
    }
  }

  void changeReadStatus() {
    post.changeReadStatus(!post.read);
    update(['read_status']);
  }

  void changeFavoriteStatus() {
    post.changeFavorite();
    update(['favorite']);
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

  @override
  void onClose() {
    _cancelToken.cancel();
    super.onClose();
  }

  static const String parametersPost = 'post';
  static const String parametersFontDir = 'font_dir';
}
