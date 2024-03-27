import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:get/get.dart';

class BuiltInFeedController extends GetxController
    with GetTickerProviderStateMixin {
  ParseFeedServices? _parseFeedservice;

  List<BuiltInFeedBean> _feedBean = [];
  List<BuiltInFeedBean> get feedBean => _feedBean;

  void _loadJson() async {
    _feedBean = _parseFeedservice?.feedBean ?? [];
    update();
  }

  @override
  void onReady() async {
    super.onReady();
    _parseFeedservice = Get.find<ParseFeedServices>();
    _loadJson();
  }

  void parseItem(BuiltInFeedBean? bean) async {
    bean?.parseStatus = ParseStatus.loading;
    update();
    _parseFeedservice
        ?.parseFeeds([ParseFeed(url: bean?.url, categoryName: bean?.categorie)],
            resultCallback: (result) {
      bean
        ?..feed = result.feedBean
        ..parseStatus = result.feedBean == null ? ParseStatus.error : null;
      update();
    });
  }

  void parseAll() async {
    final parseData = _feedBean
        .where((element) => element.url != null && element.feed == null)
        .map((e) {
      e.parseStatus = ParseStatus.loading;
      return ParseFeed(url: e.url, categoryName: e.categorie);
    }).toList();
    update();
    _parseFeedservice?.parseFeeds(parseData, resultCallback: (result) {
      _feedBean.firstWhere((element) => element.url == result.url)
        ..feed = result.feedBean
        ..parseStatus = result.feedBean == null ? ParseStatus.error : null;
      update();
    });
  }
}
