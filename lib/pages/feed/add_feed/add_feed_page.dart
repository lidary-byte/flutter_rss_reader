import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/pages/feed/add_feed/add_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:get/get.dart';

class AddFeedPage extends StatelessWidget {
  AddFeedPage({super.key});

  final _controller = Get.put(AddFeedController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('addFeed'.tr),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                expandedHeight: 170.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(children: [
                    TextField(
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
                            FocusScope.of(context)
                                .requestFocus(FocusNode()); // 收起键盘
                            _controller.parse(
                                url: _controller.urlController.text);
                          },
                          child: Text('parse'.tr),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    // AnimatedSwitcher(
                    //     duration: const Duration(milliseconds: 300),
                    //     transitionBuilder: (child, animation) {
                    //       return FadeTransition(
                    //         opacity: animation,
                    //         child: child,
                    //       );
                    //     },
                    //     child: _feedWidget()
                    //     ),
                  ]),
                ),
                bottom: TabBar(tabs: [
                  GetBuilder<AddFeedController>(
                      id: 'data_zh',
                      builder: (_) =>
                          Tab(text: '中文(${_controller.feedZhBean.length})')),
                  GetBuilder<AddFeedController>(
                      id: 'data_en',
                      builder: (_) => Tab(
                          text: 'English(${_controller.feedEnBean.length})'))
                ]),
              ),
            ];
          },
          body: TabBarView(
            children: [
              GetBuilder<AddFeedController>(
                  id: 'data_zh',
                  builder: (_) => _childTabWidget(_controller.feedZhBean)),
              GetBuilder<AddFeedController>(
                  id: 'data_en',
                  builder: (_) => _childTabWidget(_controller.feedEnBean))
            ],
          ),
        ),
      ),
    );
  }

  ListView _childTabWidget(List<Items> data) => ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
              child: InkWell(
                  onTap: item.isExit == true
                      ? null
                      : () {
                          _controller.parse(
                              url: item.url,
                              category: item.categories?.firstOrNull);
                        },
                  child: _builtFeedWidget(item)));
        },
        itemCount: data.length,
      );

  Widget _builtFeedWidget(Items item) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.url ?? '',
                    style: TextStyle(fontSize: 12, color: HexColor('#8D8D8D')),
                  ),
                  const SizedBox(height: 6),
                  if (item.categories?.isNotEmpty == true)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Text(
                          item.categories?[0] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (item.isExit == true)
              Text(
                'alreadyExist'.tr,
                style: const TextStyle(color: Colors.grey),
              ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: item.isExit == true ? null : () {},
            )
          ],
        ),
      );

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
