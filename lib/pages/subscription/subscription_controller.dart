import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/utils/dir.dart';
import 'package:flutter_rss_reader/utils/parse.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  Map<String, List<Feed>> _feedListGroupByCategory = {};
  Map<String, List<Feed>> get feedListGroupByCategory =>
      _feedListGroupByCategory;

  List<Post> postList = [];
  bool onlyUnread = false;
  bool onlyFavorite = false;
  Map<int, int> unreadCount = {};
  String? fontDir;

  void getFeedList() {
    Feed.groupByCategory().then((value) {
      _feedListGroupByCategory = value;
      update();
    });
  }

  Future<void> getPostList() async {
    await Post.getAll().then(
      (value) {
        postList = value;
        update();
      },
    );
  }

  Future<void> getUnreadPost() async {
    await Post.getUnread().then((value) {
      postList = value;
      update();
    });
  }

  Future<void> getFavoritePost() async {
    await Post.getAllFavorite().then((value) {
      postList = value;
      update();
    });
  }

  Future<void> getUnreadCount() async {
    await Feed.unreadPostCount().then((value) {
      unreadCount = value;
      update();
    });
  }

  Future<void> refresh() async {
    List<Feed> feedList = await Feed.getAll();
    int failCount = 0;
    await Future.wait(
      feedList.map(
        (e) => parseFeedContent(e).then(
          (value) async {
            if (value) {
              if (onlyUnread) {
                await getUnreadPost();
              } else if (!onlyFavorite) {
                await getPostList();
              }
              await getUnreadCount();
            } else {
              failCount++;
            }
          },
        ),
      ),
    );
    if (failCount > 0) {
      // Get.snackbar(title, message)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       AppLocalizations.of(context)!.updateFailedFeeds(failCount),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     duration: const Duration(seconds: 2),
      //     action: SnackBarAction(
      //       label: AppLocalizations.of(context)!.ok,
      //       onPressed: () {},
      //     ),
      //   ),
      // );
    } else {
      // if (!mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(AppLocalizations.of(context)!.updateSuccess),
      //     behavior: SnackBarBehavior.floating,
      //     duration: const Duration(seconds: 2),
      //     action: SnackBarAction(
      //       label: AppLocalizations.of(context)!.ok,
      //       onPressed: () {},
      //     ),
      //   ),
      // );
    }
  }

  void initFontDir() {
    getFontDir().then((value) {
      fontDir = value;
      update();
    });
  }

  @override
  void onInit() {
    getFeedList();
    getPostList();
    getUnreadCount();
    initFontDir();
    super.onInit();
  }
}
