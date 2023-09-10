import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/pages/feed/feed_page_controller.dart';
import 'package:flutter_rss_reader/pages/subscription/subscription_controller.dart';
import 'package:get/get.dart';

/// 订阅列表
class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final _controller = Get.put(SubscriptionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aRead'.tr),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              // 内置订阅源
              PopupMenuItem(
                onTap: () => Get.toNamed(AppRouter.builtInFeedPageRouter),
                child: Row(
                  children: [
                    const Icon(Icons.inbox),
                    const SizedBox(width: 8),
                    Text('builtFeed'.tr)
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: _controller.toAddFeedPage,
                child: Row(
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text('addFeed'.tr)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: GetBuilder<SubscriptionController>(
            builder: (_) => _controller.feedListGroupByCategory.isEmpty
                ? _emptyWidget()
                : _contentWidget()),
      ),
    );
  }

  Widget _contentWidget() {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          // /* 计算全部未读文章数 */
          // int allUnreadCount = 0;
          // for (int count in _controller.unRead.values) {
          //   allUnreadCount += count;
          // }
          /* 计算分组未读文章数 */
          Map<String, int> unreadCountByCategory = {};
          for (String category in _controller.feedListGroupByCategory.keys) {
            int count = 0;
            for (Feed feed
                in _controller.feedListGroupByCategory[category] ?? []) {
              if (_controller.unRead[feed.id] != null) {
                count += _controller.unRead[feed.id]!;
              }
            }
            unreadCountByCategory[category] = count;
          }

          final dataKey =
              _controller.feedListGroupByCategory.keys.toList()[index];
          return Card(
            child: ExpansionTile(
              title: Text(dataKey),
              shape: Border.all(color: Colors.transparent),
              children: _childernWidgets(
                  _controller.feedListGroupByCategory[dataKey],
                  unreadCountByCategory[dataKey]),
            ),
          );
        },
        itemCount: _controller.feedListGroupByCategory.length);
  }

  List<Widget> _childernWidgets(List<Feed>? feeds, int? unReadCount) {
    if (feeds == null || feeds.isEmpty == true) {
      return [];
    }
    return feeds
        .map(
          (feed) => ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(
              left: 40,
              right: 28,
            ),
            title: Text(
              feed.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(unReadCount.toString()),
            onTap: () => Get.toNamed(AppRouter.feedPageRouter,
                arguments: {FeedPageController.parametersFeed: feed}),
          ),
        )
        .toList();
  }

  Widget _emptyWidget() {
    return Center(
        child: Text(
      'feedEmpty'.tr,
      style: const TextStyle(fontSize: 22),
    ));
  }
}
