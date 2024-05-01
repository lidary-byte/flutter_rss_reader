import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/home/home_controller.dart';
import 'package:flutter_rss_reader/widgets/anim_index_stack.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GetBuilder<HomeController>(builder: (_) {
          return NavigationBar(
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: '首页'),
                NavigationDestination(icon: Icon(Icons.settings), label: '设置')
              ],
              onDestinationSelected: _controller.changeIndex,
              selectedIndex: _controller.index);
        }),
        body: SafeArea(
            top: false,
            child: GetBuilder<HomeController>(
                builder: (_) => AnimatedIndexedStack(
                    index: _controller.index, children: _controller.pages))));
  }
}
