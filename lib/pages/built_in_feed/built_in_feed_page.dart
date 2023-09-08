import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/models/parse_help_bean.dart';
import 'package:flutter_rss_reader/pages/built_in_feed/built_in_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:flutter_rss_reader/widgets/loading_widget.dart';
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
          bottom: TabBar(
            controller: _controller.tabController,
            tabs: const [
              Tab(text: '中文'),
              Tab(text: '英文'),
            ],
          ),
          actions: [
            TextButton(
                onPressed: _controller.parseAll, child: Text('importAll'.tr))
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _controller.tabController,
            children: [
              GetBuilder<BuiltInFeedController>(
                  id: 'data_zh',
                  builder: (_) => _childTabWidget(_controller.feedZhBean)),
              GetBuilder<BuiltInFeedController>(
                  id: 'data_en',
                  builder: (_) => _childTabWidget(_controller.feedEnBean))
            ],
          ),
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
                  onTap: item.isExit == true
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
    Widget? trailing;
    if (item.isExit == true) {
      trailing = Icon(Icons.check, color: Get.theme.colorScheme.primary);
    } else if (item.parseStatus == ParseStatus.error) {
      trailing = const Icon(Icons.close_outlined, color: Colors.red);
    } else if (item.parseStatus == ParseStatus.success) {
      trailing = Icon(Icons.check, color: Get.theme.colorScheme.primary);
    } else if (item.parseStatus == ParseStatus.isExist) {
      // 已存在暂时的也算添加成功
      trailing = Icon(Icons.check, color: Get.theme.colorScheme.primary);
    } else if (item.parseStatus == ParseStatus.loading) {
      trailing = SizedBox(
        width: 24,
        height: 24,
        child: LoadingWidget(
          backgroudColor: Colors.transparent,
        ),
      );
    } else {
      trailing = null;
    }
    return Card(
        child: SectionChild(
      title: (item.feed?.name ?? item.text) ?? '',
      titleStyle: item.parseStatus == ParseStatus.error
          ? TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: HexColor('#8D8D8D'))
          : null,
      subTitle: item.feed?.description ?? item.categorie,
      onTap: item.feed == null
          ? null
          : () => Get.toNamed(AppRouter.editFeedPageRouter,
              arguments: {EditFeedController.parametersFeed: item.feed}),
      trailing: trailing,
    ));
  }
}
