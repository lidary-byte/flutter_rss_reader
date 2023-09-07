import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/parse_help_bean.dart';
import 'package:flutter_rss_reader/utils/parse_feed_util.dart';
import 'package:get/get.dart';

class AddFeedController extends GetxController {
  final TextEditingController _urlController = TextEditingController();
  TextEditingController get urlController => _urlController;

  List<ParseHelpBean>? _parseHelp;
  List<ParseHelpBean> get parseHelp => _parseHelp ?? [];

  ///  从剪贴板获取订阅源地址，光标移到末尾
  void clipBoard() async {
    final value = (await Clipboard.getData('text/plain'))?.text;
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
        .map((match) => ParseHelpBean(
            url: match.group(0)!, parseStatus: ParseStatus.loading))
        .where(
            (element) => element.url != null && element.url?.isBlank == false)
        .toList();
    update(['list_view']);
    _parseList();
  }

  void _parseList() async {
    if (_parseHelp?.isEmpty == true) {
      return;
    }
    for (int i = 0; i < _parseHelp!.length; i++) {
      final item = _parseHelp![i];
      final url = item.url ?? '';
      final localFeed = await Feed.isExistToFeed(url);
      if (localFeed != null) {
        item.parseStatus = ParseStatus.isExist;
        item.feed = localFeed;
        update(['list_view']);
        continue;
      }
      final feed = await parseFeed(url);
      if (feed == null) {
        item.parseStatus = ParseStatus.error;
        update(['list_view']);
        continue;
      }
      item.parseStatus = ParseStatus.success;
      item.feed = feed;
      _saveOrUpdate(feed);
    }
  }

  void _saveOrUpdate(Feed? feed) async {
    if (feed == null) {
      return;
    }

    // 如果 feed 不存在，添加 feed，否则更新 feed
    if (await Feed.isExist(feed.url)) {
      await feed.updatePostsFeedNameAndOpenTypeAndFullText();
    } else {
      await feed.insertOrUpdateToDb();
    }
    update(['list_view']);
  }
}
