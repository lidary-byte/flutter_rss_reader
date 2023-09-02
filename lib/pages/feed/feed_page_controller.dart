import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/base/api_provider.dart';
import 'package:flutter_rss_reader/base/base_status_controller.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
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
  Feed? _feed;
  Feed? get feed => _feed;

  final List<Post> _postList = [];
  List<Post> get postList => _postList;

  /// 是否已读
  bool _onlyUnread = false;
  bool get onlyUnread => _onlyUnread;

  bool _onlyFavorite = false;
  bool get onlyFavorite => _onlyFavorite;
  String? _fontDir;

  @override
  void onInit() {
    _feed = Get.arguments[parametersFeed];
    super.onInit();
    _initFontDir();
  }

  @override
  void onReady() {
    super.onReady();
    refreshPost();
  }

  void refreshPost() async {
    if (_feed != null) {
      updateLoadingStatus(updateIds: ['post_list']);
      bool parseFeed = await parsePosts(feed!);
      if (!parseFeed) {
        toast(parseFeed ? 'updateSuccess'.tr : 'updateFailed'.tr);
        return;
      }
      if (_onlyUnread) {
        getUnreadPostList();
      } else if (_onlyFavorite) {
        getFavoritePostList();
      } else {
        getPostList();
      }
    }
  }

  void getPostList({List<String> refreshIds = const ['post_list']}) async {
    _addPostListData(await feed?.getPostByFeeds(), refreshIds: refreshIds);
  }

  Future<void> getUnreadPostList(
      {List<String> refreshIds = const ['post_list']}) async {
    _addPostListData(
        (await Post.getAllByFeeds([feed!]))
            .where((element) => !element.read)
            .toList(),
        refreshIds: refreshIds);
  }

  Future<void> getFavoritePostList(
      {List<String> refreshIds = const ['post_list']}) async {
    _addPostListData(
        (await Post.getAllByFeeds([feed!]))
            .where((element) => element.favorite)
            .toList(),
        refreshIds: refreshIds);
  }

  void _addPostListData(List<Post>? list,
      {List<String> refreshIds = const ['post_list']}) {
    _postList.clear();
    _postList.addAll(list ?? []);
    updateSuccessStatus(_postList, updateIds: refreshIds);
  }

  void changeReadStatus() {
    _onlyUnread = !_onlyUnread;
    _onlyFavorite = false;
    if (_onlyUnread) {
      getUnreadPostList(
          refreshIds: ['post_list', 'only_unread', 'only_favorite']);
    } else {
      getPostList(refreshIds: ['post_list', 'only_unread', 'only_favorite']);
    }
  }

  void changeFavoriteStatus() {
    _onlyFavorite = !_onlyFavorite;
    _onlyUnread = false;
    if (_onlyFavorite) {
      getFavoritePostList(
          refreshIds: ['post_list', 'only_unread', 'only_favorite']);
    } else {
      getPostList(refreshIds: ['post_list', 'only_unread', 'only_favorite']);
    }
  }

  /// 全部已读
  void markPostsAsRead() async {
    await Post.markAllRead(postList);
    refresh();
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
    if (post.openType == 1) {
      /* 在应用内标签页中打开 */
      openUrl(post.link);
    } else if (post.openType == 2) {
      /* 系统浏览器打开 */
      launchUrl(
        Uri.parse(post.link),
        mode: LaunchMode.externalApplication,
      );
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
  void dispose() {
    ApiProvider().dio.close();
    super.dispose();
  }

  static const String parametersFeed = 'feed';
}
