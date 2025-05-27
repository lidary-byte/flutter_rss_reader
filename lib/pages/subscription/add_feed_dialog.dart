import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/route/app_router.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/pages/subscription/subscription_controller.dart';
import 'package:flutter_rss_reader/widgets/button.dart';
import 'package:flutter_rss_reader/widgets/feed_parse_status_widget.dart';
import 'package:get/get.dart';

class AddFeedDialog extends StatelessWidget {
  AddFeedDialog({super.key});
  final _controller = Get.find<SubscriptionController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller.urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                hintText: '请输入订阅源地址',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(onTap: _controller.clipBoard, text: '粘贴'),
                const SizedBox(width: 24),
                Button(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
                    _controller.parseUrlString();
                  },
                  text: '导入',
                ),
                const SizedBox(width: 24),
              ],
            ),
            const SizedBox(height: 24),
            if (_controller.parseFeed != null)
              GetBuilder<SubscriptionController>(
                builder: (_) {
                  final item = _controller.parseFeed!;
                  return Card(
                    child: ListTile(
                      title: Text((item.feed?.name ?? item.url) ?? ''),
                      subtitle: Text(item.feed?.description ?? ''),
                      onTap: item.feed == null
                          ? null
                          : () => Get.toNamed(
                              AppRouter.editFeedPageRouter,
                              arguments: {
                                EditFeedController.parametersFeed: item.feed,
                              },
                            ),
                      trailing: FeedParseStatusWidget(
                        item: item,
                        onImport: _controller.parseUrlString,
                        onError: _controller.parseUrlString,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
