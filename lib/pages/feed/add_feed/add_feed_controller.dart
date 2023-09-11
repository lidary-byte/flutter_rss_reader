import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:flutter_rss_reader/utils/clip_util.dart';
import 'package:get/get.dart';

class AddFeedController extends GetxController {
  final TextEditingController _urlController = TextEditingController();
  TextEditingController get urlController => _urlController;

  List<BuiltInFeedBean>? _parseHelp;
  List<BuiltInFeedBean> get parseHelp => _parseHelp ?? [];

  final _parseService = Get.find<ParseFeedServices>();

  ///  从剪贴板获取订阅源地址，光标移到末尾
  void clipBoard() async {
    final value = await ClipUtil.getClipboardData();
    if (value != null && value.isBlank == false) {
      _urlController.text = value;
      _urlController.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    }
  }

  void parseUrlString() {
    String url = _urlController.text;
    if (url.isEmpty) {
      return;
    }
    _urlController.clear();
    RegExp regExp = RegExp(r'https?://[^\s]+');
    _parseHelp = regExp
        .allMatches(url)
        .map((match) => BuiltInFeedBean(url: match.group(0)!))
        .where(
            (element) => element.url != null && element.url?.isBlank == false)
        .toList();
    _parseService.parseFeedUrlList(_parseHelp, onRefresh: (data) {
      _parseHelp = data;
      update(['list_view']);
    });
  }

  void parseBuiltInFeed(BuiltInFeedBean? bean) {
    _parseService.parseFeedItem(bean, onRefresh: (data) {
      update(['list_view']);
    });
  }
}
