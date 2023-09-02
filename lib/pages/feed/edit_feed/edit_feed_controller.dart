import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:get/get.dart';

class EditFeedController extends GetxController {
  Feed? _feed;
  Feed? get feed => _feed;

  final TextEditingController _urlController = TextEditingController();
  TextEditingController get urlController => _urlController;
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  final TextEditingController _categoryController = TextEditingController();
  TextEditingController get categoryController => _categoryController;
  final List<String> openTypeList = [
    'openInApp'.tr,
    'openInBuiltInTab'.tr,
    'openInSystemBrowser'.tr,
  ];
  @override
  void onInit() {
    super.onInit();
    _feed = Get.arguments[parametersFeed];
    _urlController.text = _feed?.url ?? '';
    _nameController.text = _feed?.name ?? '';
    _categoryController.text = _feed?.category ?? '';
  }

  void saveOrUpdate() async {
    feed?.name = _nameController.text;
    feed?.category = _categoryController.text;
    // 如果 feed 不存在，添加 feed，否则更新 feed

    if (await Feed.isExist(feed?.url ?? '')) {
      await feed?.updatePostsFeedNameAndOpenTypeAndFullText();
    } else {
      await feed?.insertOrUpdateToDb();
    }
    Get.back(result: true);
  }

  void readFillText(bool value) {
    feed?.fullText = value;
    update(['switch_filltext']);
  }

  void openType(int? value) {
    feed?.openType = value ?? 0;
    update(['radio_open_type']);
  }

  static const String parametersFeed = 'feed';
}
