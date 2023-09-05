import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/pages/built_in_feed/built_in_feed_controller.dart';
import 'package:get/get.dart';

/// 内置订阅源
class BuiltInFeedPage extends StatelessWidget {
  BuiltInFeedPage({super.key});

  final _controller = Get.put(BuiltInFeedController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 设置选项卡的数量
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: '中文'),
              Tab(text: '英文'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GetBuilder<BuiltInFeedController>(
                id: 'data_zh',
                builder: (_) => _childWidget(_controller.feedZhBean)),
            GetBuilder<BuiltInFeedController>(
                id: 'data_en',
                builder: (_) => _childWidget(_controller.feedEnBean))
          ],
        ),
      ),
    );
  }

  ListView _childWidget(List<Items> data) => ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = data[index];
          return InkWell(
            onTap: () {
              _controller.parse(item.url);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(item.url ?? ''),
                  Text(item.categories?[0] ?? '')
                ],
              ),
            ),
          );
        },
        itemCount: data.length,
      );
}
