import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/pages/feed/feed_page_controller.dart';
import 'package:flutter_rss_reader/pages/feed/item_rss_widget.dart';
import 'package:flutter_rss_reader/widgets/status_page.dart';
import 'package:get/get.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
  final _controller = Get.put(FeedPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async => _controller.refreshPost(),
        child: GetBuilder<FeedPageController>(
            id: 'post_list',
            builder: (_) => StatusPage<List<RssItemBean>>(
                  contentWidget: (data) {
                    return ListView.separated(
                      itemCount: data.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        return Card(
                          child: InkWell(
                            onTap: () => _controller.openPost(index),
                            child: ItemRssWidget(rssItem: data[index]),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                    );
                  },
                  status: _controller.pageStatusBean,
                )),
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
          onTap: _controller.editFeed,
          child: Text('editFeed'.tr),
        ),

        // 删除订阅源
        PopupMenuItem(
          onTap: _controller.deleteFeed,
          child: Text('deleteFeed'.tr),
        ),
      ];
}
