import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
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
          IconButton(
              onPressed: _controller.toAddFeedPage, icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: GetBuilder<SubscriptionController>(
            builder: (_) => _controller.feedListGroupByCategory.isEmpty
                ? _emptyWidget()
                : _contentWidget()),
      ),
    );
    // return CustomScrollView(
    //   slivers: [
    //     SliverAppBar.large(
    //       title: Text('aRead'.tr),
    //       actions: [
    //         IconButton(
    //             onPressed: _controller.toAddFeedPage,
    //             icon: const Icon(Icons.add))
    //       ],
    //     ),
    //     GetBuilder<SubscriptionController>(
    //         builder: (_) => _controller.feedListGroupByCategory.isEmpty
    //             ? _emptyWidget()
    //             : _contentWidget()),
    //   ],
    // );
  }

  Widget _contentWidget() {
    return ListView.builder(
        itemBuilder: (context, index) {
          final dataKey =
              _controller.feedListGroupByCategory.keys.toList()[index];
          final dataValue = _controller.feedListGroupByCategory[dataKey];
          return ExpansionTile(
            title: Text(dataKey),
            shape: Border.all(color: Colors.transparent),
            children: dataValue?.isEmpty == true
                ? []
                : dataValue!
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
                        onTap: () => Get.toNamed(AppRouter.feedPageRouter,
                            arguments: {
                              FeedPageController.parametersFeed: feed
                            }),
                      ),
                    )
                    .toList(),
          );
        },
        itemCount: _controller.feedListGroupByCategory.length);
  }

  Widget _emptyWidget() {
    return SliverToBoxAdapter(
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 240),
          child: Text(
            'feedEmpty'.tr,
            style: const TextStyle(fontSize: 22),
          )),
    );
  }
}
