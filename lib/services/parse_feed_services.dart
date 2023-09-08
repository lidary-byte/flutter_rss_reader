import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/parse_help_bean.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/utils/parse_feed_util.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// 自定义回调函数，接受List参数
typedef RefreshCallback = void Function(List<BuiltInFeedBean>?);

class ParseFeedServices extends GetxService {
  Future<ParseFeedServices> init() async {
    //初始化本地数据库
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [FeedSchema, PostSchema],
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
      _parseFeedUrlList(_feedZhBean, onRefresh: onRefresh);
    } else if (type == 'en') {
      _parseFeedUrlList(_feedEnBean, onRefresh: onRefresh);
    }
  }

  void _parseFeedUrlList(List<BuiltInFeedBean>? items,
      {RefreshCallback? onRefresh}) async {
    if (items == null || items.isEmpty == true) {
      return;
    }

    // 将所有的状态改为加载中
    for (var element in items) {
      element.parseStatus = ParseStatus.loading;
    }

    onRefresh?.call(items);
    for (var item in items) {
      final url = item.url ?? '';
      final localFeed = await Feed.isExistToFeed(url);
      if (localFeed != null) {
        item.parseStatus = ParseStatus.isExist;
        item.feed = localFeed;
        onRefresh?.call(items);
        continue;
      }
      final feed = await parseFeed(url, categoryName: item.categorie);
      if (feed == null) {
        item.parseStatus = ParseStatus.error;
        onRefresh?.call(items);
        continue;
      }
      item.parseStatus = ParseStatus.success;
      item.feed = feed;
      _saveOrUpdate(
        feed,
        items,
        onRefresh: onRefresh,
      );
    }
  }

  void _saveOrUpdate(Feed? feed, List<BuiltInFeedBean>? items,
      {RefreshCallback? onRefresh}) async {
    if (feed == null) {
      return;
    }
    // 如果 feed 不存在，添加 feed，否则更新 feed
    if (await Feed.isExist(feed.url)) {
      await feed.updatePostsFeedNameAndOpenTypeAndFullText();
    } else {
      await feed.insertOrUpdateToDb();
    }
    onRefresh?.call(items);
  }
}
