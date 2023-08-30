import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  Map<String, List<Feed>> _feedListGroupByCategory = {};
  Map<String, List<Feed>> get feedListGroupByCategory =>
      _feedListGroupByCategory;

  void toAddFeedPage() {
    // 跨页面了 不能通过result刷新
    Get.toNamed(AppRouter.addFeedPageRouter);
    // ?.then((value) {
    //   if (value != null && value) {
    //     getFeedList();
    //   }
    // });
  }

  void getFeedList() async {
    _feedListGroupByCategory = await Feed.groupByCategory();
    update();
  }

  @override
  void onReady() {
    super.onReady();
    getFeedList();
  }
}
