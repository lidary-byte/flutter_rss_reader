// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rss_reader/models/feed.dart';
// import 'package:flutter_rss_reader/webfeed/domain/atom_feed.dart';
// import 'package:flutter_rss_reader/webfeed/domain/rss_feed.dart';
// import 'package:get/get.dart';

// /// 解析订阅源
// /// 参数：订阅源地址
// /// 返回：[Feed] 对象
// /// 注意：同时考虑 RSS 和 Atom 格式
// Future<Feed?> parseFeed(
//   String url, {
//   String? categoryName,
//   String? feedName,
// }) async {
//   if (categoryName == null || categoryName.isBlank == true) {
//     categoryName = '默认分类';
//   }

//   try {
//     final response = await Dio().get(url);
//     final postXmlString = response.data;
//     try {
//       /* 使用 RSS 格式解析 */
//       final RssFeed rssFeed = RssFeed.parse(postXmlString);
//       feedName = rssFeed.title;
//       return Feed(
//         name: feedName ?? '',
//         url: url,
//         description: rssFeed.description ?? '',
//         category: categoryName,
//         fullText: false,
//         openType: 0,
//       );
//     } catch (e) {
//       debugPrint('rss解析异常:$e');
//       /* 使用 Atom 格式解析 */
//       final AtomFeed atomFeed = AtomFeed.parse(postXmlString);
//       return Feed(
//         name: atomFeed.title ?? '',
//         url: url,
//         description: atomFeed.subtitle ?? '',
//         category: categoryName,
//         fullText: false,
//         openType: 0,
//       );
//     }
//   } catch (e) {
//     debugPrint('rss解析异常:$e');
//     return null;
//   }
// }
