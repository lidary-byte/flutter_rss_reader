import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/base/api_provider.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/webfeed/domain/atom_feed.dart';
import 'package:flutter_rss_reader/webfeed/domain/atom_item.dart';
import 'package:flutter_rss_reader/webfeed/domain/rss_feed.dart';
import 'package:flutter_rss_reader/webfeed/domain/rss_item.dart';
import 'package:get/get.dart';

/// 解析订阅源
/// 参数：订阅源地址
/// 返回：[Feed] 对象
/// 注意：同时考虑 RSS 和 Atom 格式
Future<FeedBean?> parseFeed(
  String url, {
  CancelToken? cancelToken,
  String? categoryName,
  String? feedName,
}) async {
  try {
    final response = await ApiProvider().dio.get(url, cancelToken: cancelToken);
    final postXmlString = response.data;

    try {
      /* 使用 RSS 格式解析 */
      final RssFeed rssFeed = RssFeed.parse(postXmlString);

      if (feedName == null || feedName.isBlank == true) {
        feedName = rssFeed.title;
      }

      if (categoryName == null || categoryName.isBlank == true) {
        categoryName = rssFeed.categories?.firstOrNull?.value ?? '默认分类';
      }

      final feed = FeedBean(
          name: feedName ?? '',
          description: rssFeed.description ?? '',
          category: categoryName,
          unReadCount: rssFeed.items?.length ?? 0,
          url: url);
      final id = await feed.insert();
      if (id != null) {
        feed.item = buildRssItem(id, feedName ?? '', rssFeed.items);
      }

      return feed;
    } catch (e) {
      debugPrint('rss解析异常 1:$e');
      /* 使用 Atom 格式解析 */
      final AtomFeed atomFeed = AtomFeed.parse(postXmlString);

      if (feedName == null || feedName.isBlank == true) {
        feedName = atomFeed.title;
      }
      if (categoryName == null || categoryName.isBlank == true) {
        categoryName = atomFeed.categories?.firstOrNull?.label ?? '默认分类';
      }

      final feed = FeedBean(
          name: feedName ?? '',
          description: atomFeed.subtitle ?? '',
          category: categoryName,
          unReadCount: atomFeed.items?.length ?? 0,
          url: url);
      final id = await feed.insert();
      if (id != null) {
        feed.item = buildAtomItem(id, feedName ?? '', atomFeed.items);
      }
      return feed;
    }
  } catch (e) {
    debugPrint('rss解析异常 2:$e');
    return null;
  }
}

/// 刷新rssItem
Future<FeedBean?> refreshFeedItem(
  FeedBean feedBean, {
  CancelToken? cancelToken,
}) async {
  try {
    final response = await ApiProvider()
        .dio
        .get(feedBean.url ?? '', cancelToken: cancelToken);
    final postXmlString = response.data;

    try {
      /* 使用 RSS 格式解析 */
      final RssFeed rssFeed = RssFeed.parse(postXmlString);
      feedBean.item = buildRssItem(feedBean.id, feedBean.name, rssFeed.items);
      return feedBean;
    } catch (e) {
      debugPrint('rss解析异常 1:$e');
      /* 使用 Atom 格式解析 */
      final AtomFeed atomFeed = AtomFeed.parse(postXmlString);
      feedBean.item = buildAtomItem(feedBean.id, feedBean.name, atomFeed.items);
      return feedBean;
    }
  } catch (e) {
    debugPrint('rss解析异常 2:$e');
    return null;
  }
}

List<RssItemBean> buildRssItem(
    int feedId, String feedName, List<RssItem>? item) {
  return item
          ?.map((e) => RssItemBean(
              feedId: feedId,
              feedName: feedName,
              title: e.title,
              link: e.link,
              description: e.description,
              pubDate: e.pubDate,
              author: e.author,
              media: e.media)
            ..insert())
          .toList() ??
      [];
}

List<RssItemBean> buildAtomItem(
    int feedId, String feedName, List<AtomItem>? item) {
  return item
          ?.map((e) => RssItemBean(
              feedId: feedId,
              feedName: feedName,
              title: e.title,
              link: e.links?.firstOrNull?.href,
              description: e.content,
              pubDate: e.updated,
              author: e.authors?.firstOrNull?.name,
              media: e.media)
            ..insert())
          .toList() ??
      [];
}

/// 通过 title 判断 [Post] 是否屏蔽
bool isBlock(String postTitle) {
  List<String> blockList = prefs.getStringList('blockList') ?? [];
  bool blockStatue = false;
  for (String block in blockList) {
    if (postTitle.contains(block)) {
      blockStatue = true;
      break;
    }
  }
  return blockStatue;
}
