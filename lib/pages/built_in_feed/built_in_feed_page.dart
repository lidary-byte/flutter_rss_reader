import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/built_in_feed/built_in_feed_controller.dart';
import 'package:flutter_rss_reader/widgets/feed_parse_status_widget.dart';
import 'package:get/get.dart';

/// 内置订阅源页面
class BuiltInFeedPage extends StatelessWidget {
  BuiltInFeedPage({super.key});

  final _controller = Get.put(BuiltInFeedController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: GetBuilder<BuiltInFeedController>(
              builder: (_) => CustomScrollView(
                    slivers: [
                      SliverAppBar.medium(
                        title: const Text('内置RSS'),
                        actions: [
                          TextButton(
                              onPressed: _controller.parseAll,
                              child: const Text('全部导入'))
                        ],
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(12.0),
                        sliver: SliverList.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _controller.feedBean[index];
                            return Card(
                              child: ListTile(
                                  onTap: null,
                                  title: Text(
                                      (item.feed?.name ?? item.text) ?? ''),
                                  subtitle: Text(item.feed?.description ?? ''),
                                  trailing: FeedParseStatusWidget(
                                    item: item,
                                    onImport: () => _controller.parseItem(item),
                                    onError: () => _controller.parseItem(item),
                                  )),
                            );
                          },
                          itemCount: _controller.feedBean.length,
                        ),
                      )
                    ],
                  )),
        ));
  }
}
