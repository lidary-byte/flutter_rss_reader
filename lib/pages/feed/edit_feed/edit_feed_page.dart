import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/feed/edit_feed/edit_feed_controller.dart';
import 'package:flutter_rss_reader/utils/clip_util.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:flutter_rss_reader/widgets/button.dart';
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
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('feedUrl'.tr),
                    const SizedBox(height: 6),
                    InkWell(
                      splashColor: Colors.transparent,
                      child: TextField(
                        clipBehavior: Clip.hardEdge,
                        controller: _controller.urlController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          enabled: false,
                        ),
                      ),
                      onTap: () => ClipUtil.setClipboardData(
                          _controller.urlController.text),
                    ),
                    const SizedBox(height: 16),
                    Text('feedName'.tr),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controller.nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: HexColor('#8D8D8D'), width: 1)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('feedCategory'.tr),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controller.categoryController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: HexColor('#8D8D8D'), width: 1)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
                child: GetBuilder<EditFeedController>(
              id: 'switch_filltext',
              builder: (_) => SwitchListTile.adaptive(
                activeColor: Get.theme.primaryColor,
                value: _controller.feed?.fullText ?? false,
                title: Text('fullText'.tr),
                onChanged: _controller.readFillText,
              ),
            )),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('postOpenWith'.tr),
                    ...(_controller.openTypeList
                        .map((item) => GetBuilder<EditFeedController>(
                            id: 'radio_open_type',
                            builder: (_) => RadioListTile.adaptive(
                                  activeColor: Get.theme.primaryColor,
                                  value: _controller.openTypeList.indexOf(item),
                                  groupValue: _controller.feed?.openType,
                                  title: Text(item),
                                  onChanged: _controller.openType,
                                )))
                        .toList())
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  onTap: () => Get.back(),
                  text: 'cancel'.tr,
                ),
                const SizedBox(width: 24),
                Button(
                  onTap: _controller.saveOrUpdate,
                  text: 'save'.tr,
                ),
                const SizedBox(width: 18),
              ],
            )
          ],
        ),
      )),
    );
  }
}
