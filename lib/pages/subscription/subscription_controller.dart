import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/feed_category_bean.dart';
import 'package:flutter_rss_reader/database/database_feed.dart';
import 'package:flutter_rss_reader/database/database_helper.dart';
import 'package:flutter_rss_reader/route/app_router.dart';
import 'package:flutter_rss_reader/services/parse_feed.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:flutter_rss_reader/utils/clip_util.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  List<FeedCategoryBean> _feedListGroup = [];
  List<FeedCategoryBean> get feedListGroup => _feedListGroup;
  final TextEditingController _urlController = TextEditingController();
  TextEditingController get urlController => _urlController;
  BuiltInFeedBean? _parseFeed;
  BuiltInFeedBean? get parseFeed => _parseFeed;

  final _parseService = Get.find<ParseFeedServices>();
  @override
  void onInit() async {
    super.onInit();

    /// 对数据源进行监听 有变化时刷新
    // (await isarInstance).feedBeans.watchLazy().listen((_) {
    //   getFeedList();
    // });
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
    _feedListGroup = await DatabaseFeed.groupByCategoryFeedList();
    update();
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

  /// 解析地址
  void parseUrlString() {
    String url = _urlController.text;
    if (url.isEmpty) {
      return;
    }
    _parseFeed = BuiltInFeedBean(url: url, parseStatus: ParseStatus.loading);
    update();
    _parseService.parseFeeds(
      [ParseFeed(url: url)],
      resultCallback: (data) {
        _parseFeed
          ?..feed = data.feedBean
          ..parseStatus = data.feedBean == null ? ParseStatus.error : null;
        update();
        if (parseFeed?.feed != null) {
          _urlController.clear();
        }
      },
    );
  }

  void dismissBottomSheet() {
    _parseFeed = null;
    urlController.clear();
  }
}
