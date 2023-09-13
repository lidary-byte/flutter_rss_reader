import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/feed_category_bean.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/utils/clip_util.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  List<FeedCategoryBean> _feedListGroup = [];
  List<FeedCategoryBean> get feedListGroup => _feedListGroup;
  final TextEditingController _urlController = TextEditingController();
  TextEditingController get urlController => _urlController;

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

  ///  从剪贴板获取订阅源地址，光标移到末尾
  void clipBoard() async {
    final value = await ClipUtil.getClipboardData();
    if (value != null && value.isBlank == false) {
      _urlController.text = value;
      _urlController.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    }
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
