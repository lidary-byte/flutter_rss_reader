import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting/setting_page.dart';
import 'package:flutter_rss_reader/pages/subscription/subscription_page.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<Widget> pages = [SubscriptionPage(), SettingPage()];

  int _index = 0;
  int get index => _index;
  void changeIndex(int index) {
    if (index == _index) {
      return;
    }

    _index = index;
    update();
  }
}
