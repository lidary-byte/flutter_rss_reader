import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/base/base_status_controller.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/db/database_feed.dart';
import 'package:flutter_rss_reader/db/database_helper.dart';
import 'package:flutter_rss_reader/db/database_rss_item.dart';
import 'package:flutter_rss_reader/route/app_router.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/utils/dir.dart';
import 'package:flutter_rss_reader/utils/open_url_util.dart';
import 'package:flutter_rss_reader/utils/web_feed_parse_util.dart';
import 'package:get/get.dart';

class FeedPageController extends BaseGetxController {
  final CancelToken _cancelToken = CancelToken();

  FeedBean? _feed;
  FeedBean? get feed => _feed;

  final List<RssItemBean> _rssItems = [];

  ///  只显示未读
  bool _onlyUnread = false;
  bool get onlyUnread => _onlyUnread;

  /// 只显示加标签的
  bool _onlyFavorite = false;
  bool get onlyFavorite => _onlyFavorite;
  String? _fontDir;
  String? get fontDir => _fontDir;

  ///  监听数据是否被更改
  Stream<void>? _rssItemsSteream;
  @override
  void onInit() async {
    _feed = Get.arguments[parametersFeed];

    super.onInit();
    _initFontDir();
    // _rssItemsSteream = (await isarInstance).rssItemBeans.watchLazy();
    _rssItemsSteream?.listen((_) {
      getPostListToSql();
    });
  }

  @override
  void onReady() {
    super.onReady();
    refreshPost();
  }

  void refreshPost() async {
    getPostListToSql();
    if (_feed != null) {
      // 网络请求刷新
      await refreshFeedItem(feed!, cancelToken: _cancelToken);
    }
  }

  void getPostListToSql({List<String> refreshIds = const ['post_list']}) async {
    if (_onlyUnread) {
      _addPostListData(
        (await feed?.rssItemsByFeedsWithUnRead()),
        refreshIds: refreshIds,
      );
    } else if (_onlyFavorite) {
      _addPostListData(
        (await feed?.rssItemsByFeedsWithFavorite())
            ?.where((element) => element.favorite)
            .toList(),
        refreshIds: refreshIds,
      );
    } else {
      _addPostListData(await feed?.rssItemsByFeeds(), refreshIds: refreshIds);
    }
  }

  void _addPostListData(
    List<RssItemBean>? list, {
    List<String> refreshIds = const ['post_list'],
  }) {
    _rssItems.clear();
    _rssItems.addAll(list ?? []);
    updateSuccessStatus(list, updateIds: refreshIds);
  }

  /// 查询未读
  void changeReadStatus() {
    _onlyUnread = !_onlyUnread;
    _onlyFavorite = false;
    getPostListToSql(refreshIds: ['post_list', 'popup_menu']);
  }

  void changeFavoriteStatus() {
    _onlyFavorite = !_onlyFavorite;
    _onlyUnread = false;
    getPostListToSql(refreshIds: ['post_list', 'popup_menu']);
  }

  /// 全部已读
  void markPostsAsRead() async {
    await DatabaseRssItem.markAllRead(_rssItems);
  }

  void deleteFeed() {
    Get.dialog(
      AlertDialog(
        title: Text('deleteFeed'.tr),
        content: Text('doYouWantToDeleteThisFeed'.tr),
        actions: [
          TextButton(onPressed: Get.back, child: Text('cancel'.tr)),
          TextButton(
            onPressed: () async {
              await feed?.deleteFromDb();
              Get.back();
              Get.back();
            },
            child: Text('ok'.tr),
          ),
        ],
      ),
    );
  }

  void openPost(int index) {
    final rssItem = _rssItems[index];
    if (rssItem.openType == 1 || rssItem.openType == 2) {
      openUrl(url: rssItem.link, thisApp: rssItem.openType == 1);
    } else {
      Get.toNamed(
        AppRouter.readPageRouter,
        arguments: {ReadController.parametersPost: rssItem},
      );
    }
    // 标记文章为已读
    rssItem.changeReadStatus(true);
  }

  void editFeed() {
    Get.toNamed(
      AppRouter.editFeedPageRouter,
      arguments: {EditFeedController.parametersFeed: _feed},
    )?.then((value) => _feed = value);
  }

  void _initFontDir() async {
    _fontDir = await getFontDir();
  }

  @override
  void onClose() {
    _cancelToken.cancel();
    super.onClose();
  }

  static const String parametersFeed = 'feed';
}
