import 'package:dio/dio.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/db/database_feed.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/http/dio_manager.dart';
import 'package:flutter_rss_reader/utils/rss/feed_util.dart';
import 'package:rss_feed_parser/domain/rss1_feed.dart';
import 'package:rss_feed_parser/rss_feed_parser.dart';

enum RssFormat { rss1, rss2, atom, unknown }

class RssParseUtil {
  /// 获取 Feed 并自动解析格式
  static Future<FeedBean?> fetchFeed(
    String url, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await DioManager.getInstance().get<String>(
        url,
        cancelToken: cancelToken,
      );
      final xml = response.data ?? '';
      final format = _detectRssFormat(xml);

      // logger.e('RSS 获取失败: $format');
      if (format == RssFormat.rss1) {
        return _parseRss1(Rss1Feed.parse(xml));
      }
      if (format == RssFormat.rss2) {
        return await _parseRss2(RssFeed.parse(xml));
      }
      if (format == RssFormat.atom) {
        return _parseAtom(AtomFeed.parse(xml));
      }
      return null;
    } catch (e) {
      logger.e('RSS 获取失败: $e');
      return null;
    }
  }

  // /// 获取所有条目
  // static Future<List<RssItem>> fetchItems(String url) async {
  //   final (feed, _) = await fetchFeed(url);
  //   return feed?.items ?? [];
  // }

  static FeedBean _parseRss1(Rss1Feed feed) {
    return FeedBean(
        name: feed.title ?? '',
        description: feed.description ?? '',
        iconUrl: feed.link,
        category: '默认分类',
        unReadCount: feed.items.length,
        url: feed.link,
      )
      ..item = feed.items
          .map(
            (item) => RssItemBean(
              feedId: 0,
              feedName: item.title ?? '',
              title: item.title ?? '',
              link: item.link,
              description: item.description,
              pubDate: '',
            ),
          )
          .toList()
      ..insert();
  }

  static Future<FeedBean> _parseRss2(RssFeed feed) async {
    final items = await Future.wait(
      feed.items.map((item) async {
        return RssItemBean(
          feedId: 0,
          feedName: item.title ?? '',
          title: item.title ?? '',
          shortDescription: await FeedUtil.parseToText(item.link),
          link: item.link,
          description: item.description,
          pubDate: '',
          cover: FeedUtil.findThumbnail(
            item.content?.value ?? item.description,
          ),
          content: item.content?.value,
        );
      }).toList(),
    );

    final feedBean =
        FeedBean(
            name: feed.title ?? '',
            description: feed.description ?? '',
            iconUrl: feed.link,
            category: '默认分类',
            unReadCount: feed.items.length,
            url: feed.link,
          )
          ..item = items
          ..insert();

    return feedBean;
  }

  static FeedBean _parseAtom(AtomFeed feed) {
    return FeedBean(
        name: feed.title ?? '',
        description: feed.subtitle ?? '',
        iconUrl: feed.icon,
        category: '默认分类',
        unReadCount: feed.items.length,
        url: feed.links.firstOrNull?.href ?? '',
      )
      ..item = feed.items
          .map(
            (item) => RssItemBean(
              feedId: 0,
              feedName: item.title ?? '',
              title: item.title ?? '',
              link: item.links.firstOrNull?.href ?? '',
              description: item.summary ?? '',
              pubDate: '',
            ),
          )
          .toList()
      ..insert();
  }

  /// 判断 RSS 格式
  static RssFormat _detectRssFormat(String xml) {
    if (xml.contains('<rdf:RDF') ||
        xml.contains('http://www.w3.org/1999/02/22-rdf-syntax-ns#')) {
      return RssFormat.rss1;
    }
    if (xml.contains('<rss') && xml.contains('version="2.0"')) {
      return RssFormat.rss2;
    }
    if (xml.contains('<feed') && xml.contains('http://www.w3.org/2005/Atom')) {
      return RssFormat.atom;
    }
    return RssFormat.unknown;
  }
}
