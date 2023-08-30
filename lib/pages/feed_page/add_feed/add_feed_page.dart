import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/pages/feed_page/add_feed/add_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed_page/edit_feed/edit_feed_controller.dart';
import 'package:get/get.dart';

class AddFeedPage extends StatelessWidget {
  AddFeedPage({super.key});

  final _controller = Get.put(AddFeedController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('addFeed'.tr),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          children: [
            TextField(
              autofocus: true,
              controller: _controller.urlController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'enterFeedUrl'.tr,
                labelText: 'feedUrl'.tr,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _controller.clipBoard,
                  child: Text('paste'.tr),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
                    _controller.parse();
                  },
                  child: Text('parse'.tr),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _feedWidget())
          ],
        ),
      ),
    );
  }

  Widget _feedWidget() => GetBuilder<AddFeedController>(
      id: 'feed',
      builder: (_) => _controller.feed == null
          ? const SizedBox.shrink()
          : Card(
              elevation: 0,
              color: Get.theme.colorScheme.surfaceVariant,
              child: ListTile(
                title: Text(_controller.feed?.name ?? ''),
                subtitle: Text(
                  _controller.feed?.description ?? '',
                  style: Get.theme.textTheme.bodySmall,
                ),
                minVerticalPadding: 12,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                onTap: () => Get.offAndToNamed(AppRouter.editFeedPageRouter,
                    arguments: {
                      EditFeedController.parametersFeed: _controller.feed
                    }),
              ),
            ));
}
