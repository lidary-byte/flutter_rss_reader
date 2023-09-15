import 'package:dio/dio.dart';
import 'package:flutter_rss_reader/base/api_provider.dart';
import 'package:flutter_rss_reader/base/base_status_controller.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/database/database_rss_item.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_main_element/html_main_element.dart';

class ReadController extends BaseGetxController {
  final CancelToken _cancelToken = CancelToken();

  RssItemBean rssItem = Get.arguments[parametersPost];
  String fontDir = Get.arguments[parametersFontDir];

  int fontSize = prefs.getInt('fontSize') ?? 18;
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  String textAlign = prefs.getString('textAlign') ?? 'justify';
  String customCss = prefs.getString('customCss') ?? '';

  String _titleStr = '';
  String get titleStr => _titleStr;

  String? _contentHtml; // 内容 html
  String? get contentHtml => _contentHtml;
  // 根据 url 获取 html 内容
  void _initData() async {
    if (rssItem.fullText &&
        rssItem.cacheContent == null &&
        rssItem.openType == 0) {
      getHtml();
    } else {
      _contentHtml = rssItem.description;
      updateSuccessStatus(contentHtml, updateIds: ['content', 'html_widget']);
      _changeStyle = false;
      if (!rssItem.read) {
        rssItem.read = true;
      }
      rssItem.updateToDb();
    }
  }

  void getHtml() async {
    updateLoadingStatus(updateIds: ['content']);

    final response =
        await ApiProvider().dio.get(rssItem.link!, cancelToken: _cancelToken);
    final document = html_parser.parse(response.data);

    final bestElemReadability =
        readabilityMainElement(document.documentElement!);
    rssItem.cacheContent = bestElemReadability.innerHtml;

    _contentHtml = rssItem.cacheContent;
    updateSuccessStatus(contentHtml, updateIds: ['content', 'html_widget']);
    _changeStyle = false;
    if (!rssItem.read) {
      rssItem.read = true;
    }
    rssItem.updateToDb();
  }

  @override
  void onReady() {
    super.onReady();
    _titleStr = '<h1>${rssItem.title}</h1>';
    _initData();
  }

  void changeStylePage() {
    Get.toNamed(AppRouter.readSettingPage)?.then((value) {
      if (_changeStyle) {
        update(['html_widget']);
      }
    });
  }

  void changeReadStatus() {
    rssItem.changeReadStatus(!rssItem.read);
    update(['popup']);
  }

  void changeFavoriteStatus() {
    rssItem.changeFavorite();
    update(['popup']);
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
