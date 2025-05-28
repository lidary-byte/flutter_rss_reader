import 'package:dio/dio.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/http/dio_manager.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/db/database_feed.dart';
import 'package:flutter_rss_reader/db/database_rss_item.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:rss_feed_parser/domain/atom_feed.dart';
import 'package:rss_feed_parser/domain/atom_item.dart';
import 'package:rss_feed_parser/domain/rss_feed.dart';
import 'package:rss_feed_parser/domain/rss_item.dart';

/// return的为url:Feed
/// [params] = {
///  String? url,
///  CancelToken? cancelToken,
///  String? categoryName,
///  String? feedName,
/// }
@pragma('vm:entry-point')
Future<ParseFeedResult> isoParseFeed(ParseFeed parseFeed) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(
    parseFeed.rootIsolateToken!,
  );
  // final CancelToken? cancelToken = params['cancelToken'];
  // String? feedName = parseFeed.feedName;
  // 判断该url是否已经存在
  final existFeed = await DatabaseFeed.isExist(parseFeed.url ?? '');
  if (existFeed != null) {
    return ParseFeedResult(url: parseFeed.url, feedBean: existFeed);
  }
  try {
    final response = await Dio(
      BaseOptions(sendTimeout: Duration.zero),
    ).get(parseFeed.url ?? '');
    final postXmlString = response.data;

    try {
      /* 使用 RSS 格式解析 */
      final RssFeed rssFeed = RssFeed.parse(postXmlString);

      // 根据url获取icon
      final iconUrl = await webIcon(rssFeed.link ?? '');
      final feed = FeedBean(
        name: rssFeed.title ?? '',
        description: rssFeed.description ?? '',
        iconUrl: iconUrl,
        category: rssFeed.categories.firstOrNull?.value ?? '默认分类',
        unReadCount: rssFeed.items.length,
        url: parseFeed.url,
      );
      final id = await feed.insert();
      return ParseFeedResult(
        url: parseFeed.url,
        feedBean: feed
          ..item = buildRssItem(id, rssFeed.title ?? '', rssFeed.items),
      );
    } catch (e) {
      logger.d('rss解析异常 1:$e');
      /* 使用 Atom 格式解析 */
      final AtomFeed atomFeed = AtomFeed.parse(postXmlString);
      // 根据url获取icon
      final iconUrl = await webIcon(atomFeed.links.firstOrNull?.href ?? '');
      final feed = FeedBean(
        name: atomFeed.title ?? '',
        description: atomFeed.subtitle ?? '',
        category: atomFeed.categories.firstOrNull?.label ?? '默认分类',
        iconUrl: iconUrl,
        unReadCount: atomFeed.items.length,
        url: parseFeed.url,
      );

      final id = await feed.insert();
      return ParseFeedResult(
        url: parseFeed.url,
        feedBean: feed
          ..item = buildAtomItem(id, atomFeed.title ?? '', atomFeed.items),
      );
    }
  } catch (e) {
    logger.d('rss解析异常 2:$e');
    return ParseFeedResult(url: parseFeed.url, feedBean: null);
  }
}

/// 刷新rssItem
Future<FeedBean?> refreshFeedItem(
  FeedBean feedBean, {
  CancelToken? cancelToken,
}) async {
  try {
    final response = await DioManager.getInstance().get(
      feedBean.url ?? '',
      cancelToken: cancelToken,
    );
    final postXmlString = response.data;
    try {
      /* 使用 RSS 格式解析 */
      final RssFeed rssFeed = RssFeed.parse(postXmlString);
      // feedBean.item = buildRssItem(feedBean.id, feedBean.name, rssFeed.items);
      return feedBean;
    } catch (e) {
      debugPrint('rss解析异常 1:$e');
      /* 使用 Atom 格式解析 */
      final AtomFeed atomFeed = AtomFeed.parse(postXmlString);
      // feedBean.item = buildAtomItem(feedBean.id, feedBean.name, atomFeed.items);
      return feedBean;
    }
  } catch (e) {
    debugPrint('rss解析异常 2:$e');
    return null;
  }
}

List<RssItemBean> buildRssItem(
  int? feedId,
  String feedName,
  List<RssItem>? item,
) {
  if (feedId == null) {
    return [];
  }
  return item?.map((e) {
        return RssItemBean(
          feedId: feedId,
          feedName: feedName,
          title: e.title,
          link: e.link,
          description: e.description,
          pubDate: e.pubDate,
          author: e.author ?? e.dc?.creator,
          cover: e.content?.images.firstOrNull,
        )..insert();
      }).toList() ??
      [];
}

List<RssItemBean> buildAtomItem(
  int? feedId,
  String feedName,
  List<AtomItem>? item,
) {
  if (feedId == null) {
    return [];
  }
  return item?.map((e) {
        return RssItemBean(
          feedId: feedId,
          feedName: feedName,
          title: e.title,
          link: e.links.firstOrNull?.href,
          description: e.content,
          pubDate: e.updated,
          author: e.authors.firstOrNull?.name,
        )..insert();
      }).toList() ??
      [];
}

/// 通过 title 判断 [Post] 是否屏蔽
bool isBlock(String postTitle) {
  List<String> blockList = []; //prefs.getStringList('blockList') ?? [];
  bool blockStatue = false;
  for (String block in blockList) {
    if (postTitle.contains(block)) {
      blockStatue = true;
      break;
    }
  }
  return blockStatue;
}

/// 根据[url]获取网站icon
Future<String?> webIcon(String url) async {
  Uri uri = Uri.parse(url);
  var iconUrl = await FaviconFinder.getBest('${uri.scheme}://${uri.host}');
  return iconUrl?.url;
}
