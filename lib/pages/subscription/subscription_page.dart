import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/pages/feed/feed_page_controller.dart';
import 'package:flutter_rss_reader/pages/subscription/add_feed_dialog.dart';
import 'package:flutter_rss_reader/pages/subscription/subscription_controller.dart';
import 'package:get/get.dart';

/// 订阅列表
class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final _controller = Get.put(SubscriptionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: GetBuilder<SubscriptionController>(
            builder: (_) => CustomScrollView(
              slivers: [
                SliverAppBar.medium(
                  title: const Text('ARead'),
                  actions: [
                    IconButton(
                        onPressed: () => Get.bottomSheet(
                              AddFeedDialog(),
                              // shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.vertical(
                              //         top: Radius.circular(10)))
                            ).then((value) => _controller.dismissBottomSheet()),
                        icon: const Icon(Icons.add_outlined)),
                    IconButton(
                        onPressed: () =>
                            Get.toNamed(AppRouter.builtInFeedPageRouter),
                        icon: const Icon(Icons.feed)),
                  ],
                ),
                _controller.feedListGroup.isEmpty
                    ? _emptyWidget().sliverBox
                    : _contentWidget()
              ],
            ),
          )),
    );
  }

  Widget _contentWidget() {
    return SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Card(
                child: ExpansionTile(
                  title: Text(_controller.feedListGroup[index].category ?? ''),
                  shape: Border.all(color: Colors.transparent),
                  children:
                      _childernWidgets(_controller.feedListGroup[index].feeds),
                ),
              );
            },
            itemCount: _controller.feedListGroup.length));
  }

  List<Widget> _childernWidgets(List<FeedBean>? feeds) {
    if (feeds == null || feeds.isEmpty == true) {
      return [];
    }
    return feeds
        .map(
          (feed) => ListTile(
            leading: feed.iconUrl == null
                ? null
                : CachedNetworkImage(
                    width: 20,
                    height: 20,
                    imageUrl: feed.iconUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            contentPadding: const EdgeInsets.only(
              left: 40,
              right: 28,
            ),
            title: Text(
              feed.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(feed.unReadCount.toString()),
            onTap: () => Get.toNamed(AppRouter.feedPageRouter,
                arguments: {FeedPageController.parametersFeed: feed}),
          ),
        )
        .toList();
  }

  Widget _emptyWidget() {
    return const Padding(
      padding: EdgeInsets.only(top: 200),
      child: Center(
          child: Text(
        '你还没有订阅源',
        style: TextStyle(fontSize: 22),
      )),
    );
  }
}
