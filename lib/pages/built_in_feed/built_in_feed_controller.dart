import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
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

  void parseAll() async {
    final type = _tabController?.index == 0 ? 'zh' : 'en';
    _parseFeedservice?.parseLocalRss(type, onRefresh: (parseBean) {
      update(['data_$type']);
    });
  }

  void parseItem(BuiltInFeedBean? bean) async {
    final type = _tabController?.index == 0 ? 'zh' : 'en';
    _parseFeedservice?.parseFeedItem(bean, onRefresh: (parseBean) {
      update(['data_$type']);
    });
  }
}
