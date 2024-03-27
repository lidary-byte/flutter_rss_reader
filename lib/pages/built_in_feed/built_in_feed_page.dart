import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/bean/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/pages/built_in_feed/built_in_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:flutter_rss_reader/widgets/feed_parse_status_widget.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:get/get.dart';

/// 内置订阅源页面
class BuiltInFeedPage extends StatelessWidget {
  BuiltInFeedPage({super.key});

  final _controller = Get.put(BuiltInFeedController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('builtFeed'.tr),
          actions: [
            TextButton(
                onPressed: _controller.parseAll, child: Text('importAll'.tr))
          ],
        ),
        body: SafeArea(
          child: GetBuilder<BuiltInFeedController>(
              builder: (_) => _childTabWidget(_controller.feedBean)),
        ),
      ),
    );
  }

  ListView _childTabWidget(List<BuiltInFeedBean> data) => ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
              child: InkWell(
                  onTap: item.feed == null
                      ? null
                      : () {
                          // _controller.parse(
                          //     url: item.url,
                          //     category: item.categories?.firstOrNull);
                        },
                  child: _builtFeedWidget(item)));
        },
        itemCount: data.length,
      );

  Widget _builtFeedWidget(BuiltInFeedBean item) {
    return Card(
        child: SectionChild(
            title: (item.feed?.name ?? item.text) ?? '',
            titleStyle: item.parseStatus == ParseStatus.error
                ? TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#8D8D8D'))
                : null,
            subTitle: item.feed?.description,
            onTap: item.feed == null
                ? null
                : () => Get.toNamed(AppRouter.editFeedPageRouter,
                    arguments: {EditFeedController.parametersFeed: item.feed}),
            trailing: FeedParseStatusWidget(
              item: item,
              onImport: () => _controller.parseItem(item),
              onError: () => _controller.parseItem(item),
            )));
  }
}
