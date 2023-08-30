import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/app_router.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/widgets/list_tile_group_title.dart';
import 'package:get/get.dart';

class EditFeedPage extends StatelessWidget {
  EditFeedPage({super.key});
  final _controller = Get.put(EditFeedController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('editFeed'.tr),
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: _controller.urlController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'feedUrl'.tr,
                    enabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: _controller.nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'feedName'.tr,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: _controller.categoryController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'feedCategory'.tr,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GetBuilder<EditFeedController>(
                id: 'switch_filltext',
                builder: (_) => SwitchListTile(
                  value: _controller.feed?.fullText == 1,
                  title: Text('fullText'.tr),
                  onChanged: _controller.readFillText,
                ),
              ),
              ListTileGroupTitle(title: 'postOpenWith'.tr),
            ]),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              final item = _controller.openTypeList[index];
              return GetBuilder<EditFeedController>(
                  id: 'radio_open_type',
                  builder: (_) => RadioListTile(
                        value: _controller.openTypeList.indexOf(item),
                        groupValue: _controller.feed?.openType,
                        title: Text(item),
                        onChanged: _controller.openType,
                      ));
            },
            itemCount: _controller.openTypeList.length,
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      Get.offAndToNamed(AppRouter.addFeedPageRouter),
                  child: Text('cancel'.tr),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: _controller.saveOrUpdate,
                  child: Text('save'.tr),
                ),
                const SizedBox(width: 18),
              ],
            ),
          )
        ],
      )),
    );
  }
}
