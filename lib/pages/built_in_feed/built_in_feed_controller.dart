import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:get/get.dart';

class BuiltInFeedController extends GetxController
    with GetTickerProviderStateMixin {
  ParseFeedServices? _parseFeedservice;
  TabController? _tabController;
  TabController? get tabController => _tabController;

  List<BuiltInFeedBean> _feedZhBean = [];
  List<BuiltInFeedBean> get feedZhBean => _feedZhBean;
  List<BuiltInFeedBean> _feedEnBean = [];
  List<BuiltInFeedBean> get feedEnBean => _feedEnBean;

  @override
  void onInit() {
    _tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  void _loadJson() async {
    _feedZhBean = _parseFeedservice?.feedZhBean ?? [];
    update(['data_zh', 'tab_zh']);

    _feedEnBean = _parseFeedservice?.feedEnBean ?? [];
    update(['data_en', 'tab_en']);
  }

  @override
  void onReady() async {
    super.onReady();
    _parseFeedservice = Get.find<ParseFeedServices>();
    _loadJson();
  }

  void parseItem(BuiltInFeedBean? bean) async {
    final type = _tabController?.index == 0 ? 'zh' : 'en';
    bean?.parseStatus = ParseStatus.loading;
    update(['data_$type']);
    _parseFeedservice
        ?.parseFeeds([ParseFeed(url: bean?.url, categoryName: bean?.categorie)],
            resultCallback: (result) {
      bean
        ?..feed = result.feedBean
        ..parseStatus = result.feedBean == null ? ParseStatus.error : null;
      update(['data_$type']);
    });
  }

  void parseAll() async {
    final type = _tabController?.index == 0 ? 'zh' : 'en';
    final data = _tabController?.index == 0 ? _feedZhBean : _feedEnBean;
    final parseData = data
        .where((element) => element.url != null && element.feed == null)
        .map((e) {
      e.parseStatus = ParseStatus.loading;
      return ParseFeed(url: e.url, categoryName: e.categorie);
    }).toList();
    update(['data_$type']);
    _parseFeedservice?.parseFeeds(parseData, resultCallback: (result) {
      data.firstWhere((element) => element.url == result.url)
        ..feed = result.feedBean
        ..parseStatus = result.feedBean == null ? ParseStatus.error : null;
      update(['data_$type']);
    });
  }
}
