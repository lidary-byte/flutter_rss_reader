import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/pages/feed/add_feed/add_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:flutter_rss_reader/widgets/button.dart';
import 'package:flutter_rss_reader/widgets/feed_parse_status_widget.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:get/get.dart';

class AddFeedPage extends StatelessWidget {
  AddFeedPage({super.key});

  final _controller = Get.put(AddFeedController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('addFeed'.tr),
        actions: [
          TextButton(
              onPressed: () => Get.toNamed(AppRouter.builtInFeedPageRouter),
              child: Text('builtFeed'.tr))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              // autofocus: true,
              minLines: 5,
              controller: _controller.urlController,

              decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 200),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('#8D8D8D'), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Get.theme.primaryColor, width: 1)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  hintText: 'enterFeedUrl'.tr,
                  hintMaxLines: 10),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                onTap: _controller.clipBoard,
                text: 'paste'.tr,
              ),
              const SizedBox(width: 24),
              Button(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
                  _controller.parseUrlString();
                },
                text: 'import'.tr,
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
              child: GetBuilder<AddFeedController>(
                  id: 'list_view',
                  builder: (_) => ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _controller.parseHelp[index];

                          return Card(
                              child: SectionChild(
                            title: (item.feed?.name ?? item.url) ?? '',
                            titleStyle: item.feed == null
                                ? TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#8D8D8D'))
                                : null,
                            subTitle: item.feed?.description,
                            onTap: item.feed == null
                                ? null
                                : () => Get.toNamed(
                                        AppRouter.editFeedPageRouter,
                                        arguments: {
                                          EditFeedController.parametersFeed:
                                              item.feed
                                        }),
                            trailing: FeedParseStatusWidget(
                              item: item,
                              onImport: () =>
                                  _controller.parseBuiltInFeed(item),
                              onError: () => _controller.parseBuiltInFeed(item),
                            ),
                          ));
                        },
                        itemCount: _controller.parseHelp.length,
                      )))
        ],
      ),
    );
  }
}
