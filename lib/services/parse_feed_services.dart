import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/database/database_feed.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/utils/web_feed_parse_util.dart';
import 'package:get/get.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:opml/opml.dart';

typedef ParseResultCallback = void Function(ParseFeedResult result);

class ParseFeedServices extends GetxService {
  /// feed解析的Iso
  IsolateManager<ParseFeedResult, ParseFeed>? isolateManager;

  Future<ParseFeedServices> init() async {
    isolateManager = IsolateManager.create(
      isoParseFeed,
      concurrent: 5,
      workerName: 'parse feed',
    );
    // isolateManager.stream.listen((result) => );

    /// 存储当前数据库版本
    // prefs.setInt('db_version', 1);

    return this;
  }

  /// 解析rss 数组
  /// [map]key为url value为categorie
  void parseFeeds(
    List<ParseFeed> map, {
    ParseResultCallback? resultCallback,
  }) async {
    ///获取 Token
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

    for (var itemMap in map) {
      final result = await isolateManager!.compute(
        itemMap..rootIsolateToken = rootIsolateToken,
        callback: (value) => true,
      );
      resultCallback?.call(result);
    }
  }

  void parseFeed(String path) async {
    final File opmlFile = File(path);
    final String opmlString = await opmlFile.readAsString();
    final opml = OpmlDocument.parse(opmlString);
    for (var category in opml.body) {
      category.children?.forEach((opmlOutline) async {
        if (await DatabaseFeed.isExist(opmlOutline.xmlUrl!) == null) {
          (await isoParseFeed(
            ParseFeed(
              url: opmlOutline.xmlUrl,
              rootIsolateToken: RootIsolateToken.instance!,
            ),
          )).feedBean;
        }
      });
    }
  }
}
