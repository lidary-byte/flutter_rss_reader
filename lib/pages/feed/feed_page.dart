import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/feed_page_controller.dart';
import 'package:flutter_rss_reader/widgets/post_container.dart';
import 'package:get/get.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
  final _controller = Get.put(FeedPageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedPageController>(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(_controller.feed?.name ?? ''),
                actions: [
                  GetBuilder<FeedPageController>(
                      id: 'only_unread',
                      builder: (_) => IconButton(
                            onPressed: _controller.changeReadStatus,
                            icon: _controller.onlyUnread
                                ? const Icon(Icons.radio_button_checked)
                                : const Icon(Icons.radio_button_unchecked),
                          )),
                  GetBuilder<FeedPageController>(
                      id: 'only_favorite',
                      builder: (_) => IconButton(
                            onPressed: _controller.changeFavoriteStatus,
                            icon: _controller.onlyFavorite
                                ? const Icon(Icons.bookmark)
                                : const Icon(Icons.bookmark_border_outlined),
                          )),
                  PopupMenuButton(
                    position: PopupMenuPosition.under,
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          onTap: _controller.markPostsAsRead,
                          child: Text('markAllAsRead'.tr),
                        ),
                        PopupMenuItem(
                          onTap: () => Get.toNamed(AppRouter.editFeedPageRouter,
                              arguments: {
                                EditFeedController.parametersFeed:
                                    _controller.feed,
                                EditFeedController.editFeed: true
                              }),
                          child: Text('editFeed'.tr),
                        ),
                        const PopupMenuDivider(),
                        // 删除订阅源
                        PopupMenuItem(
                          onTap: _controller.deleteFeed,
                          child: Text('deleteFeed'.tr),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async => _controller.refreshPost(),
                  child: GetBuilder<FeedPageController>(
                      id: 'post_list',
                      builder: (_) => ListView.separated(
                            itemCount: _controller.postList.length,
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _controller.openPost(index),
                                child: PostContainer(
                                    post: _controller.postList[index]),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 4);
                            },
                          )),
                ),
              ),
            ));
  }
}
