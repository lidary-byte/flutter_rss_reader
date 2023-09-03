import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/base/base_status_controller.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:flutter_rss_reader/utils/dir.dart';
import 'package:flutter_rss_reader/utils/open_url_util.dart';
import 'package:flutter_rss_reader/utils/parse_post_util.dart';
import 'package:flutter_rss_reader/widgets/toast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPageController extends BaseGetxController {
  final CancelToken _cancelToken = CancelToken();

  Feed? _feed;
  Feed? get feed => _feed;

  final List<Post> _postList = [];
  // List<Post> get postList => _postList;

  ///  只显示未读
  bool _onlyUnread = false;
  bool get onlyUnread => _onlyUnread;

  /// 只显示加标签的
  bool _onlyFavorite = false;
  bool get onlyFavorite => _onlyFavorite;
  String? _fontDir;

  ///  监听数据是否被更改
  Stream<void>? _postSteream;
  @override
  void onInit() {
    _feed = Get.arguments[parametersFeed];
    super.onInit();
    _initFontDir();
    _postSteream = isar.posts.watchLazy();
    _postSteream?.listen((_) {
      getPostListToSql();
    });
  }

  @override
  void onReady() {
    super.onReady();
    refreshPost();
  }

  void refreshPost() async {
    if (_feed != null) {
      //初始化数据库
      updateLoadingStatus(updateIds: ['post_list']);
      bool parseFeed = await parsePosts(feed!, cancelToken: _cancelToken);

      if (!parseFeed) {
        toast(parseFeed ? 'updateSuccess'.tr : 'updateFailed'.tr);
        return;
      }
      getPostListToSql();
    }
  }

  void getPostListToSql({List<String> refreshIds = const ['post_list']}) async {
    if (_onlyUnread) {
      _addPostListData(
          (await feed?.getPostByFeeds())
              ?.where((element) => !element.read)
              .toList(),
          refreshIds: refreshIds);
    } else if (_onlyFavorite) {
      _addPostListData(
          (await feed?.getPostByFeeds())
              ?.where((element) => element.favorite)
              .toList(),
          refreshIds: refreshIds);
    } else {
      _addPostListData(await feed?.getPostByFeeds(), refreshIds: refreshIds);
    }
  }

  void _addPostListData(List<Post>? list,
      {List<String> refreshIds = const ['post_list']}) {
    _postList.clear();
    _postList.addAll(list ?? []);
    updateSuccessStatus(list, updateIds: refreshIds);
  }

  /// 查询未读
  void changeReadStatus() {
    _onlyUnread = !_onlyUnread;
    _onlyFavorite = false;
    getPostListToSql(refreshIds: ['post_list', 'only_unread', 'only_favorite']);
  }

  void changeFavoriteStatus() {
    _onlyFavorite = !_onlyFavorite;
    _onlyUnread = false;
    getPostListToSql(refreshIds: ['post_list', 'only_unread', 'only_favorite']);
  }

  /// 全部已读
  void markPostsAsRead() async {
    await Post.markAllRead(_postList);
  }

  void deleteFeed() {
    Get.dialog(AlertDialog(
      title: Text('deleteFeed'.tr),
      content: Text(
        'doYouWantToDeleteThisFeed'.tr,
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () async {
            await feed?.deleteFromDb();
            Get.back();
            Get.back();
          },
          child: Text('ok'.tr),
        ),
      ],
    ));
  }

  void openPost(int index) async {
    final post = _postList[index];
    if (post.openType == 1 || post.openType == 2) {
      openUrl(post.link, thisApp: post.openType == 1);
    } else {
      Get.toNamed(AppRouter.readPageRouter, arguments: {
        ReadController.parametersFontDir: _fontDir,
        ReadController.parametersPost: _postList[index]
      });
    }
    // 标记文章为已读
    if (!_postList[index].read) {
      _postList[index].markAsRead();
    }
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
