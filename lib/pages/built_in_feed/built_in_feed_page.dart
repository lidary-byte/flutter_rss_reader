import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/pages/built_in_feed/built_in_feed_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:get/get.dart';

/// 内置订阅源页面
class BuiltInFeedPage extends StatelessWidget {
  BuiltInFeedPage({super.key});

  final _controller = Get.put(BuiltInFeedController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 设置选项卡的数量
      child: Scaffold(
        appBar: AppBar(
          title: Text('builtFeed'.tr),
          bottom: const TabBar(
            tabs: [
              Tab(text: '中文'),
              Tab(text: '英文'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              GetBuilder<BuiltInFeedController>(
                  id: 'data_zh',
                  builder: (_) => _childTabWidget(_controller.feedZhBean)),
              GetBuilder<BuiltInFeedController>(
                  id: 'data_en',
                  builder: (_) => _childTabWidget(_controller.feedEnBean))
            ],
          ),
        ),
      ),
    );
  }

  ListView _childTabWidget(List<Items> data) => ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
              child: InkWell(
                  onTap: item.isExit == true
                      ? null
                      : () {
                          // _controller.parse(
                          //     url: item.url,
                          //     category: item.categories?.firstOrNull);
                        },
                  child: _builtFeedWidget(item)));
        },
        itemCount: data.length,
      );
  Widget _builtFeedWidget(Items item) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.url ?? '',
                    style: TextStyle(fontSize: 12, color: HexColor('#8D8D8D')),
                  ),
                  const SizedBox(height: 6),
                  if (item.categories?.isNotEmpty == true)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Text(
                          item.categories?[0] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (item.isExit == true)
              Text(
                'alreadyExist'.tr,
                style: const TextStyle(color: Colors.grey),
              ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: item.isExit == true ? null : () {},
            )
          ],
        ),
      );
}
