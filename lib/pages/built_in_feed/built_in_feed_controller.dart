import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/parse_feed_util.dart';
import 'package:flutter_rss_reader/widgets/loading_widget.dart';
import 'package:flutter_rss_reader/widgets/toast.dart';
import 'package:get/get.dart';

class BuiltInFeedController extends GetxController {
  List<Items> _feedZhBean = [];
  List<Items> get feedZhBean => _feedZhBean;
  List<Items> _feedEnBean = [];
  List<Items> get feedEnBean => _feedEnBean;

  @override
  void onReady() {
    super.onReady();
    _loadJson('zh');
    _loadJson('en');
  }

  void _loadJson(String type) async {
    final jsonString = await rootBundle.loadString(
        type == 'zh' ? 'assets/featured_zh.json' : 'assets/featured_en.json');

    if (type == 'zh') {
      _feedZhBean =
          BuiltInFeedBean.fromJson(json.decode(jsonString)).result?.items ?? [];
      update(['data_zh']);
    } else {
      _feedEnBean =
          BuiltInFeedBean.fromJson(json.decode(jsonString)).result?.items ?? [];
      update(['data_en']);
    }
  }

  void parse(String? url) async {
    if (url == null || await Feed.isExist(url)) {
      toast('feedAlreadyExists'.tr);
      return;
    }

    showLoadingDialog();
    final feed = await parseFeed(url);
    if (feed == null) {
      dismissDialog();
      toast('unableToParseFeed'.tr);
      return;
    }
    dismissDialog();
    Get.toNamed(AppRouter.editFeedPageRouter,
        arguments: {EditFeedController.parametersFeed: feed});
  }
}
