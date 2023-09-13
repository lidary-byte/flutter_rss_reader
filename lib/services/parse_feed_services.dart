import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/utils/web_feed_parse_util.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:path_provider/path_provider.dart';

// 自定义回调函数，接收List参数
typedef RefreshCallback = void Function(List<BuiltInFeedBean>?);
// 自定义回调函数
typedef RefreshItemCallback = void Function(BuiltInFeedBean?);

typedef ParseResultCallback = void Function(ParseFeedResult result);

class ParseFeedServices extends GetxService {
  /// feed解析的Iso
  final IsolateManager<ParseFeedResult, ParseFeed> isolateManager =
      IsolateManager.create(isoParseFeed,
          concurrent: 5, workerName: 'parse feed');

  Future<ParseFeedServices> init() async {
    // isolateManager.stream.listen((result) => );

    //初始化本地数据库
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [FeedBeanSchema, RssItemBeanSchema],
      directory: dir.path,
    );

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

  /// 解析rss数组

  void parseFeedItem(BuiltInFeedBean? item,
      {RefreshItemCallback? onRefresh}) async {
    if (item == null) return;
    // 将不存在的或者加载异常的状态改为加载中
    item.parseStatus = ParseStatus.loading;
    onRefresh?.call(item);
    if (item.feed != null) {
      // 数据已存在
      item.parseStatus = null;
      onRefresh?.call(item);
      return;
    }
    final feed = await parseFeed(item.url!, categoryName: item.categorie);
    if (feed == null) {
      item.parseStatus = ParseStatus.error;
      onRefresh?.call(item);
      return;
    }
    item.parseStatus = null;
    item.feed = feed;
    _saveOrUpdate(
      feed,
      item,
      onRefresh: onRefresh,
    );
  }

  /// 解析rss 数组
  /// [map]key为url value为categorie
  void parseFeeds(List<ParseFeed> map,
      {ParseResultCallback? resultCallback}) async {
    final parseMap =
        map.where((element) => FeedBean.isExistSync(element.url ?? '') == null);

    for (var itemMap in parseMap) {
      final result =
          await isolateManager.compute(itemMap, callback: (value) => true);
      debugPrint(
          '--------------解析url:${result.url} ----- 解析:${result.feedBean == null ? '失败' : '成功'}');
      resultCallback?.call(result);
    }
  }

  void _saveOrUpdate(FeedBean? feed, BuiltInFeedBean? items,
      {RefreshItemCallback? onRefresh}) async {
    if (feed == null) {
      return;
    }
    feed.insert();
    onRefresh?.call(items);
  }
}
