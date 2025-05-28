import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:flutter_rss_reader/utils/rss/rss_parse_util.dart';
import 'package:get/get.dart';

class BuiltFeedController extends GetxController
    with GetTickerProviderStateMixin {
  ParseFeedServices? _parseFeedservice;

  List<BuiltInFeedBean> _feedBean = [];
  List<BuiltInFeedBean> get feedBean => _feedBean;

  final CancelToken _cancelToken = CancelToken();
  @override
  void onReady() async {
    super.onReady();
    _loadLocalRss();
    _parseFeedservice = Get.find<ParseFeedServices>();
  }

  /// 加载本地rss
  void _loadLocalRss() async {
    try {
      final jsonString = await rootBundle.loadString('assets/featured.json');
      _feedBean = BuiltInFeedBean.fromJsonList(jsonString);
      update();
    } catch (e) {
      e.printError();
    }
  }

  void parseItem(BuiltInFeedBean? bean) async {
    bean?.parseStatus = ParseStatus.loading;
    update();
    // _parseFeedservice?.parseFeeds(
    //   [ParseFeed(url: bean?.url)],
    //   resultCallback: (result) {
    //     bean
    //       ?..feed = result.feedBean
    //       ..parseStatus = result.feedBean == null ? ParseStatus.error : null;
    //     update();
    //   },
    // );
    logger.d('开始解析 ${bean?.url}');
    var feed = await RssParseUtil.fetchFeed(
      bean?.url ?? '',
      cancelToken: _cancelToken,
    );
    bean?.feed = feed;
    if (feed != null) {
      bean?.parseStatus = null;
    } else {
      bean?.parseStatus = ParseStatus.error;
    }
    update();
  }

  void parseAll() async {
    final parseData = _feedBean
        .where((element) => element.url != null && element.feed == null)
        .map((e) {
          e.parseStatus = ParseStatus.loading;
          return ParseFeed(url: e.url);
        })
        .toList();
    update();
    _parseFeedservice?.parseFeeds(
      parseData,
      resultCallback: (result) {
        _feedBean.firstWhere((element) => element.url == result.url)
          ..feed = result.feedBean
          ..parseStatus = result.feedBean == null ? ParseStatus.error : null;
        update();
      },
    );
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
