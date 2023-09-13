import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/subscription/subscription_controller.dart';
import 'package:flutter_rss_reader/widgets/button.dart';
import 'package:get/get.dart';

class DialogAddFeed extends StatelessWidget {
  DialogAddFeed({super.key});
  final _controller = Get.find<SubscriptionController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
      child: Column(
        children: [
          // Text('feedUrl'.tr),
          // const SizedBox(height: 6),
          TextField(
            controller: _controller.urlController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                hintText: 'feedUrl'.tr),
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
                  // _controller.parseUrlString();
                },
                text: 'import'.tr,
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 24),
          // GetBuilder<SubscriptionController>(
          //     id: 'list_view',
          //     builder: (_) => ListView.separated(
          //           padding: const EdgeInsets.symmetric(horizontal: 12),
          //           separatorBuilder: (context, index) =>
          //               const SizedBox(height: 8),
          //           itemBuilder: (context, index) {
          //             final item = _controller.parseHelp[index];

          //             return Card(
          //                 child: SectionChild(
          //               title: (item.feed?.name ?? item.url) ?? '',
          //               titleStyle: item.feed == null
          //                   ? TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                       color: HexColor('#8D8D8D'))
          //                   : null,
          //               subTitle: item.feed?.description,
          //               onTap: item.feed == null
          //                   ? null
          //                   : () => Get.toNamed(AppRouter.editFeedPageRouter,
          //                           arguments: {
          //                             EditFeedController.parametersFeed:
          //                                 item.feed
          //                           }),
          //               trailing: FeedParseStatusWidget(
          //                 item: item,
          //                 onImport: () => _controller.parseBuiltInFeed(item),
          //                 onError: () => _controller.parseBuiltInFeed(item),
          //               ),
          //             ));
          //           },
          //           itemCount: _controller.parseHelp.length,
          //         ))
        ],
      ),
    );
  }
}
