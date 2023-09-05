import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/post.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/feed_page_controller.dart';
import 'package:flutter_rss_reader/widgets/post_container.dart';
import 'package:flutter_rss_reader/widgets/sliver_status_page.dart';
import 'package:get/get.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
  final _controller = Get.put(FeedPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: Text(_controller.feed?.name ?? ''),
                actions: [
                  GetBuilder<FeedPageController>(
                    id: 'popup_menu',
                    builder: (_) => PopupMenuButton(
                      position: PopupMenuPosition.under,
                      itemBuilder: (BuildContext context) => _popupWidget(),
                    ),
                  )
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver:
                    // RefreshIndicator(
                    //   onRefresh: () async => _controller.refreshPost(),
                    //   child:
                    GetBuilder<FeedPageController>(
                        id: 'post_list',
                        builder: (_) => SliverStatusPage<List<Post>>(
                              contentWidget: (data) {
                                return SliverList.separated(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () => _controller.openPost(index),
                                      child: PostContainer(post: data[index]),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 4);
                                  },
                                );
                              },
                              status: _controller.pageStatusBean,
                            )),
                // )
              )
            ],
          )),
    );
  }

  List<PopupMenuEntry> _popupWidget() => [
        PopupMenuItem(
          onTap: _controller.markPostsAsRead,
          child: Text('markAllAsRead'.tr),
        ),
        const PopupMenuDivider(),

        /// 只看未读
        PopupMenuItem(
          onTap: _controller.changeReadStatus,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('onlyUnRead'.tr),
              Icon(_controller.onlyUnread
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked)
            ],
          ),
        ),
        PopupMenuItem(
          onTap: _controller.changeFavoriteStatus,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('onlyUnFavorite'.tr),
              Icon(_controller.onlyFavorite
                  ? Icons.bookmark
                  : Icons.bookmark_border_outlined)
            ],
          ),
        ),
        const PopupMenuDivider(),

        /// 编辑订阅源
        PopupMenuItem(
          onTap: () => Get.toNamed(AppRouter.editFeedPageRouter,
              arguments: {EditFeedController.parametersFeed: _controller.feed}),
          child: Text('editFeed'.tr),
        ),

        // 删除订阅源
        PopupMenuItem(
          onTap: _controller.deleteFeed,
          child: Text('deleteFeed'.tr),
        ),
      ];
}
