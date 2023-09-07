import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/models/parse_help_bean.dart';
import 'package:flutter_rss_reader/pages/feed/add_feed/add_feed_controller.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:flutter_rss_reader/widgets/list_section.dart';
import 'package:flutter_rss_reader/widgets/loading_widget.dart';
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
              autofocus: true,
              minLines: 5,
              controller: _controller.urlController,
              decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 200),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('#8D8D8D'), width: 1)),
                  focusedBorder: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  hintText: 'enterFeedUrl'.tr,
                  hintMaxLines: 10),
            ),
          ),
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
                  _controller.parseUrlString();
                },
                child: Text('add'.tr),
              ),
            ],
          ),
          Expanded(
              child: GetBuilder<AddFeedController>(
                  id: 'list_view',
                  builder: (_) => ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _controller.parseHelp[index];

                          Widget trailing;
                          if (item.parseStatus == ParseStatus.error) {
                            trailing = const Icon(Icons.close_outlined,
                                color: Colors.red);
                          } else if (item.parseStatus == ParseStatus.success) {
                            trailing = Icon(Icons.check,
                                color: Get.theme.colorScheme.primary);
                          } else if (item.parseStatus == ParseStatus.isExist) {
                            // 已存在暂时的也算添加成功
                            trailing = Icon(Icons.check,
                                color: Get.theme.colorScheme.primary);
                          } else {
                            trailing = SizedBox(
                              width: 24,
                              height: 24,
                              child: LoadingWidget(
                                backgroudColor: Colors.transparent,
                              ),
                            );
                          }
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
                            trailing: trailing,
                          ));
                        },
                        itemCount: _controller.parseHelp.length,
                      )))
        ],
      ),
    );
  }
}
