import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/feed_category_bean.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  List<FeedCategoryBean> _feedListGroup = [];
  List<FeedCategoryBean> get feedListGroup => _feedListGroup;

  Map<int, int> _unRead = {};
  Map<int, int> get unRead => _unRead;

  @override
  void onInit() {
    super.onInit();

    /// 对数据源进行监听 有变化时刷新
    isar.feedBeans.watchLazy().listen((_) {
      getFeedList();
    });
  }

  @override
  void onReady() {
    super.onReady();
    getFeedList();
  }

  void toAddFeedPage() {
    // 跨页面了 不能通过result刷新
    Get.toNamed(AppRouter.addFeedPageRouter);
  }

  void getFeedList() async {
    _feedListGroup = await FeedBean.groupByCategoryFeedList();
    update();
  }
}
