import 'package:flutter_rss_reader/global/global.dart';
import 'package:get/get.dart';

class ReadController extends GetxController {
  int fontSize = prefs.getInt('fontSize') ?? 18;
  double lineHeight = prefs.getDouble('lineheight') ?? 1.5;
  int pagePadding = prefs.getInt('pagePadding') ?? 18;
  String textAlign = prefs.getString('textAlign') ?? 'justify';
  String customCss = prefs.getString('customCss') ?? '';

  Future<void> changeFontSize(int size) async {
    await prefs.setInt('fontSize', size);
    fontSize = size;
    update();
  }

  Future<void> changeLineHeight(double height) async {
    await prefs.setDouble('lineheight', height);

    lineHeight = height;

    update();
  }

  Future<void> changePagePadding(int padding) async {
    await prefs.setInt('pagePadding', padding);

    pagePadding = padding;

    update();
  }

  Future<void> changeTextAlign(String align) async {
    await prefs.setString('textAlign', align);

    textAlign = align;
    update();
  }

  Future<void> changeCustomCss(String css) async {
    await prefs.setString('customCss', css);

    customCss = css;
    update();
  }
}
