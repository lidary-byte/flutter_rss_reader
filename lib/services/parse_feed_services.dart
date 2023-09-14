import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/utils/web_feed_parse_util.dart';
import 'package:get/get.dart';
import 'package:isolate_manager/isolate_manager.dart';

typedef ParseResultCallback = void Function(ParseFeedResult result);

class ParseFeedServices extends GetxService {
  /// feed解析的Iso
  IsolateManager<ParseFeedResult, ParseFeed>? isolateManager;

  Future<ParseFeedServices> init() async {
    isolateManager = IsolateManager.create(isoParseFeed,
        concurrent: 5, workerName: 'parse feed');
    // isolateManager.stream.listen((result) => );

    /// 存储当前数据库版本
    prefs.setInt('db_version', 1);

    _loadLocalRss('zh');
    _loadLocalRss('en');
    return this;
  }

  List<BuiltInFeedBean> _feedZhBean = [];
  List<BuiltInFeedBean> get feedZhBean => _feedZhBean;
  List<BuiltInFeedBean> _feedEnBean = [];
  List<BuiltInFeedBean> get feedEnBean => _feedEnBean;

  /// 加载本地rss
  /// [type]: zh ,en
  Future<bool> _loadLocalRss(String type) async {
    final jsonString = await rootBundle.loadString(
        type == 'zh' ? 'assets/featured_zh.json' : 'assets/featured_en.json');

    if (type == 'zh') {
      _feedZhBean = BuiltInFeedBean.fromJsonList(jsonString);
      return true;
    } else {
      _feedEnBean = BuiltInFeedBean.fromJsonList(jsonString);
      return true;
    }
  }

  /// 解析rss 数组
  /// [map]key为url value为categorie
  void parseFeeds(List<ParseFeed> map,
      {ParseResultCallback? resultCallback}) async {
    ///获取 Token
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

    // final parseMap = await Future.forEach(
    //     map,
    //     (element) async =>
    //         (await DatabaseFeed.isExist(element.url ?? '')) == null);

    for (var itemMap in map) {
      final result = await isolateManager!.compute(
          itemMap..rootIsolateToken = rootIsolateToken,
          callback: (value) => true);
      resultCallback?.call(result);
    }
  }
}
