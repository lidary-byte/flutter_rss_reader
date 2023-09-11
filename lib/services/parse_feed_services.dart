import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/utils/web_feed_parse_util.dart';
// import 'package:flutter_rss_reader/utils/parse_feed_util.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// 自定义回调函数，接收List参数
typedef RefreshCallback = void Function(List<BuiltInFeedBean>?);
// 自定义回调函数
typedef RefreshItemCallback = void Function(BuiltInFeedBean?);

class ParseFeedServices extends GetxService {
  Future<ParseFeedServices> init() async {
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

  void parseLocalRss(String type, {RefreshCallback? onRefresh}) {
    if (type == 'zh') {
      parseFeedUrlList(_feedZhBean, onRefresh: onRefresh);
    } else if (type == 'en') {
      parseFeedUrlList(_feedEnBean, onRefresh: onRefresh);
    }
  }

  /// 解析单个的feed
  void parseFeedItem(BuiltInFeedBean? item,
      {RefreshItemCallback? onRefresh}) async {
    if (item == null || item.url == null || item.feed != null) {
      return;
    }

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

    item.feed = feed;
    _saveOrUpdate(
      feed,
      item,
      onRefresh: onRefresh,
    );
  }

  /// 解析一个Feed List
  void parseFeedUrlList(List<BuiltInFeedBean>? items,
      {RefreshCallback? onRefresh}) async {
    if (items == null || items.isEmpty == true) {
      return;
    }

    // 将不存在的或者加载异常的状态改为加载中
    for (var element in items) {
      if (element.feed == null) {
        element.parseStatus = ParseStatus.loading;
      }
    }

    onRefresh?.call(items);
    for (var item in items) {
      final url = item.url ?? '';
      if (item.feed != null) {
        // 数据已存在
        item.parseStatus = null;
        onRefresh?.call(items);
        continue;
      }
      final feed = await parseFeed(url, categoryName: item.categorie);
      if (feed == null) {
        item.parseStatus = ParseStatus.error;
        onRefresh?.call(items);
        continue;
      }

      item.feed = feed;
      _saveOrUpdateList(
        feed,
        items,
        onRefresh: onRefresh,
      );
    }
  }

  void _saveOrUpdateList(FeedBean? feed, List<BuiltInFeedBean>? items,
      {RefreshCallback? onRefresh}) async {
    if (feed == null) {
      return;
    }
    // 如果 feed 不存在，添加 feed，否则更新 feed
    // if (await FeedBean.isExist(feed.url)) {
    //   await feed.updatePostsFeedNameAndOpenTypeAndFullText();
    // } else {
    //   await feed.insertOrUpdateToDb();
    // }
    feed.insert();
    onRefresh?.call(items);
  }

  void _saveOrUpdate(FeedBean? feed, BuiltInFeedBean? items,
      {RefreshItemCallback? onRefresh}) async {
    if (feed == null) {
      return;
    }
    // 如果 feed 不存在，添加 feed，否则更新 feed
    // if (await Feed.isExist(feed.url)) {
    //   await feed.updatePostsFeedNameAndOpenTypeAndFullText();
    // } else {
    //   await feed.insertOrUpdateToDb();
    // }
    feed.insert();
    onRefresh?.call(items);
  }
}
