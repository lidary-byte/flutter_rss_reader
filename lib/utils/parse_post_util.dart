// import 'package:dio/dio.dart';
// import 'package:flutter_rss_reader/base/api_provider.dart';
// import 'package:flutter_rss_reader/global/global.dart';
// import 'package:flutter_rss_reader/models/feed.dart';
// import 'package:flutter_rss_reader/models/post.dart';
// import 'package:flutter_rss_reader/webfeed/domain/atom_feed.dart';
// import 'package:flutter_rss_reader/webfeed/domain/atom_item.dart';
// import 'package:flutter_rss_reader/webfeed/domain/rss_feed.dart';
// import 'package:flutter_rss_reader/webfeed/domain/rss_item.dart';

// /// 解析订阅源内容，得到 [Post]，存入数据库
// /// 成功返回 true，失败返回 false
// /// 参数：订阅源地址
// /// 返回：是否成功
// /// 注意：如果 [Post] 已存在，则不存入数据库
// Future<bool> parsePosts(Feed feed, {CancelToken? cancelToken}) async {
//   try {
//     final response = await ApiProvider()
//         .dio
//         .get(feed.url, cancelToken: cancelToken); // Dio().get(feed.url);
//     final postXmlString = response.data;
//     final String? feedLastUpdated = await feed.getLatesPubDate();
//     try {
//       /* 使用 RSS 格式解析 */
//       RssFeed rssFeed = RssFeed.parse(postXmlString);
//       List<Future> futures = [];
//       for (RssItem item in rssFeed.items!) {
//         if (feedLastUpdated == item.pubDate.toString()) {
//           break;
//         }
//         futures.add(parseRSSPostItem(item, feed));
//       }
//       await Future.wait(futures);
//       return true;
//     } catch (e) {
//       /* 使用 Atom 格式解析 */
//       AtomFeed atomFeed = AtomFeed.parse(postXmlString);
//       List<Future> futures = [];
//       for (AtomItem item in atomFeed.items!) {
//         if (feedLastUpdated == item.updated.toString()) {
//           break;
//         }
//         futures.add(parseAtomPostFuturesItem(item, feed));
//       }
//       await Future.wait(futures);
//       return true;
//     }
//   } catch (e) {
//     return false;
//   }
// }

// /// 使用 RSS 格式解析 [RssItem]，存入数据库
// Future<void> parseRSSPostItem(RssItem item, Feed feed) async {
//   /* 判断是否屏蔽 */
//   String title = item.title!.trim();
//   bool blockStatue = isBlock(title);
//   if (blockStatue) {
//     return;
//   }
//   Post post = Post(
//     title: title,
//     feedId: feed.id!,
//     feedName: feed.name,
//     link: item.link!,
//     content: item.description ?? '',
//     pubDate: item.pubDate!.toString(),
//     read: false,
//     favorite: false,
//     fullText: feed.fullText,
//     fullTextCache: false,
//     openType: feed.openType,
//   );
//   await post.insertToDb();
// }

// /// 使用 RSS 格式解析 [AtomItem]，存入数据库
// Future<void> parseAtomPostFuturesItem(AtomItem item, Feed feed) async {
//   /* 判断是否屏蔽 */
//   String title = item.title!.trim();
//   bool blockStatue = isBlock(title);
//   if (blockStatue) {
//     return;
//   }
//   Post post = Post(
//     title: title,
//     feedId: feed.id!,
//     feedName: feed.name,
//     link: item.links![0].href!,
//     content: item.content!,
//     pubDate: item.updated!.toString(),
//     read: false,
//     favorite: false,
//     fullText: feed.fullText,
//     fullTextCache: false,
//     openType: feed.openType,
//   );
//   await post.insertToDb();
// }

// /// 通过 title 判断 [Post] 是否屏蔽
// bool isBlock(String postTitle) {
//   List<String> blockList = prefs.getStringList('blockList') ?? [];
//   bool blockStatue = false;
//   for (String block in blockList) {
//     if (postTitle.contains(block)) {
//       blockStatue = true;
//       break;
//     }
//   }
//   return blockStatue;
// }
