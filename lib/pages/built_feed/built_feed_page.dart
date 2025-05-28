import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/built_feed/built_feed_controller.dart';
import 'package:flutter_rss_reader/widgets/feed_parse_status_widget.dart';
import 'package:get/get.dart';

/// 内置订阅源页面
class BuiltFeedPage extends GetView<BuiltFeedController> {
  const BuiltFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: GetBuilder<BuiltFeedController>(
          builder: (_) => CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: const Text('内置RSS'),
                actions: [
                  TextButton(
                    onPressed: controller.parseAll,
                    child: const Text('全部导入'),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.feedBean[index];
                    return ListTile(
                      onTap: null,
                      title: Text((item.feed?.name ?? item.text) ?? ''),
                      subtitle: Text(item.feed?.description ?? ''),
                      trailing: FeedParseStatusWidget(
                        item: item,
                        onImport: () => controller.parseItem(item),
                        onError: () => controller.parseItem(item),
                      ),
                    );
                  },
                  itemCount: controller.feedBean.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
