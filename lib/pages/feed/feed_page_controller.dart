import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/pages/subscription/subscription_controller.dart';
import 'package:flutter_rss_reader/utils/dir.dart';
import 'package:flutter_rss_reader/utils/parse.dart';
import 'package:flutter_rss_reader/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedPageController extends GetxController {
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
      bool parseFeed = await parseFeedContent(_feed!);
      if (_onlyUnread) {
        getUnreadPostList();
      } else if (_onlyFavorite) {
        getFavoritePostList();
      } else {
        getPostList();
      }
      if (!parseFeed) {
        showSnackBar(
            content: parseFeed ? 'updateSuccess'.tr : 'updateFailed'.tr);
      }
    }
  }

  void getPostList({List<String> refreshIds = const ['post_list']}) async {
    _addPostListData(await feed?.getAllPosts(), refreshIds: refreshIds);
  }

  Future<void> getUnreadPostList(
      {List<String> refreshIds = const ['post_list']}) async {
    _addPostListData(await feed?.getUnreadPosts(), refreshIds: refreshIds);
  }

  Future<void> getFavoritePostList(
      {List<String> refreshIds = const ['post_list']}) async {
    _addPostListData(await feed?.getAllfavoritePosts(), refreshIds: refreshIds);
  }

  void _addPostListData(List<Post>? list,
      {List<String> refreshIds = const ['post_list']}) {
    _postList.clear();
    _postList.addAll(list ?? []);
    if (_postList.isNotEmpty) {
      update(refreshIds);
    }
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
    await feed?.markPostsAsRead();
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
            // 关闭当前dialog同时关闭当前页面
            Get.find<SubscriptionController>().getFeedList();
            Get.back();
            Get.back();
          },
          child: Text('ok'.tr),
        ),
      ],
    ));
  }

  void openPost(int index) async {
    if (_postList[index].openType == 2) {
      // 打开系统浏览器
      await launchUrl(
        Uri.parse(postList[index].link),
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (_fontDir == null) return;
      // Get.to(ReadPage(
      //   post: _postList[index],
      //   fullText: _feed?.fullText == 1,
      //   fontDir: _fontDir!,
      // ))?.then((value) {
      //   // if (onlyUnread) {
      //   //   _controller.getUnreadPostList();
      //   // } else if (_controller.onlyFavorite) {
      //   //   _controller.getFavoritePostList();
      //   // } else {
      //   //   _controller.getPostList();
      //   // }
      // });
    }

    // 标记文章为已读
    if (_postList[index].read == 0) {
      _postList[index].markRead();
    }
  }

  void _initFontDir() async {
    _fontDir = await getFontDir();
  }

  static const String parametersFeed = 'feed';
}
