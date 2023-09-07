import 'dart:async';

import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ParseFeedServices extends GetxService {
  final String _zoneName = 'flutterRss';
  final String _objectTypeName = 'rss_info';

  AGConnectCloudDBZone? _zone;
  String? _currentUserUid;
  StreamSubscription<AGConnectCloudDBZoneSnapshot?>? _snapshotSubscription;
  StreamSubscription<String?>? _onEvent;
  StreamSubscription<bool?>? _onDataEncryptionKeyChanged;

  Future<ParseFeedServices> init() async {
    //初始化本地数据库
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [FeedSchema, PostSchema],
      directory: dir.path,
    );

    /// 存储当前数据库版本
    prefs.setInt('db_version', 1);

    //初始化云端数据库
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await AGConnectCloudDB.getInstance().initialize();
        await AGConnectCloudDB.getInstance().createObjectType();

        _onEvent =
            AGConnectCloudDB.getInstance().onEvent().listen((String? event) {
          debugPrint('On Event: $event');
        });
        _onDataEncryptionKeyChanged = AGConnectCloudDB.getInstance()
            .onDataEncryptionKeyChanged()
            .listen((bool? data) {
          debugPrint('Data Encryption Key Changed: $data');
        });
      } catch (e) {}
    });
    return this;
  }

  // List<ParseHelpBean>? _parseHelp;
  // List<ParseHelpBean> get parseHelp => _parseHelp ?? [];
  // void parseFeedUrlList(List<String> urls) async {
  //   if (urls.isEmpty) {
  //     return;
  //   }
  //   _parseHelp = urls
  //       .map((e) => ParseHelpBean(url: e, parseStatus: ParseStatus.loading))
  //       .toList();

  //   for (int i = 0; i < _parseHelp!.length; i++) {
  //     final item = _parseHelp![i];
  //     final url = item.url ?? '';
  //     final localFeed = await Feed.isExistToFeed(url);
  //     if (localFeed != null) {
  //       item.parseStatus = ParseStatus.isExist;
  //       item.feed = localFeed;
  //       continue;
  //     }
  //     final feed = await parseFeed(url);
  //     if (feed == null) {
  //       item.parseStatus = ParseStatus.error;
  //       update(['list_view']);
  //       continue;
  //     }
  //     item.parseStatus = ParseStatus.success;
  //     item.feed = feed;
  //     _saveOrUpdate(feed);
  //   }
  // }

  // void _saveOrUpdate(Feed? feed) async {
  //   if (feed == null) {
  //     return;
  //   }

  //   // 如果 feed 不存在，添加 feed，否则更新 feed
  //   if (await Feed.isExist(feed.url)) {
  //     await feed.updatePostsFeedNameAndOpenTypeAndFullText();
  //   } else {
  //     await feed.insertOrUpdateToDb();
  //   }
  //   update(['list_view']);
  // }

  @override
  void onClose() {
    _snapshotSubscription?.cancel();
    _onEvent?.cancel();
    _onDataEncryptionKeyChanged?.cancel();
    super.onClose();
  }
}
