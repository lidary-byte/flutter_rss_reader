import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html_main_element/html_main_element.dart';

class ReadController extends GetxController {
  final Post post = Get.arguments[parametersPost];
  final String fontDir = Get.arguments[parametersFontDir];

  int fontSize = prefs.getInt('fontSize') ?? 18;
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  String textAlign = prefs.getString('textAlign') ?? 'justify';
  String customCss = prefs.getString('customCss') ?? '';

  Map<String, Style> _cssMap = {};
  Map<String, Style> get cssMap => _cssMap;
  String _titleStr = '';
  String get titleStr => _titleStr;
  @override
  void onInit() {
    _titleStr = '<h1>${post.title}</h1>';
    _createCss();
    super.onInit();
  }

  String? _contentHtml; // 内容 html
  String? get contentHtml => _contentHtml;
  // 根据 url 获取 html 内容
  Future<void> initData(String url) async {
    if (post.fullText && !post.fullTextCache && post.openType == 0) {
      final response = await Dio().get(url);
      final document = html_parser.parse(response.data);
      final bestElemReadability =
          readabilityMainElement(document.documentElement!);
      post.content = bestElemReadability.outerHtml;
      post.read = true;
      post.fullTextCache = true;
      post.updateToDb();
    }
    _contentHtml = post.content;
    update(['content']);
    _changeStyle = false;
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('------------${post.link}');
    initData(post.link);
  }

  void changeStylePage() {
    Get.toNamed(AppRouter.readSettingPage)?.then((value) {
      if (_changeStyle) {
        _createCss();
        _changeStyle = false;
        update(['content']);
      }
    });
  }

  void _createCss() {
    _cssMap = {
      'body': Style(
        fontSize: FontSize(
          fontSize.toDouble(),
        ),
        lineHeight: LineHeight(
          lineHeight,
        ),
        textAlign: {
              'left': TextAlign.left,
              'right': TextAlign.right,
              'center': TextAlign.center,
              'justify': TextAlign.justify,
            }[textAlign] ??
            TextAlign.justify,
      ),
      'h1': Style(
        fontSize: FontSize(
          fontSize.toDouble() * 1.5,
        ),
      ),
      'h2': Style(
        fontSize: FontSize(
          fontSize.toDouble() * 1.3,
        ),
      ),
      'h3': Style(
        fontSize: FontSize(
          fontSize.toDouble() * 1.1,
        ),
      ),
      'h4': Style(
        fontSize: FontSize(
          fontSize.toDouble(),
        ),
      ),
      'h5': Style(
        fontSize: FontSize(
          fontSize.toDouble(),
        ),
      ),
      'h6': Style(
        fontSize: FontSize(
          fontSize.toDouble(),
        ),
      ),
    };
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
  static const String parametersFontDir = 'font_dir';
}
