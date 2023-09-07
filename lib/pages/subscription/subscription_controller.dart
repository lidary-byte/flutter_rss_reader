import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  Map<String, List<Feed>> _feedListGroupByCategory = {};
  Map<String, List<Feed>> get feedListGroupByCategory =>
      _feedListGroupByCategory;

  Map<int, int> _unRead = {};
  Map<int, int> get unRead => _unRead;

  Stream<void>? _feedSteream;

  @override
  void onReady() {
    super.onReady();

    /// 对数据源进行监听 有变化时刷新
    _feedSteream = isar.feeds.watchLazy();
    _feedSteream?.listen((_) {
      getFeedList();
    });
    getUnreadCount();
    getFeedList();
  }

  void toAddFeedPage() {
    // 跨页面了 不能通过result刷新
    Get.toNamed(AppRouter.addFeedPageRouter);
  }

  void getFeedList() async {
    _feedListGroupByCategory = await Feed.groupByCategory();
    update();
  }

  /* 获取未读文章数 */
  void getUnreadCount() async {
    await Feed.unreadPostCount().then((value) => _unRead = value);
  }
}
