import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:get/get.dart';

class BlockSettingPage extends StatelessWidget {
  BlockSettingPage({super.key});
  final _controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('blockRules'.tr),
        actions: [
          // 添加字体
          IconButton(
            onPressed: () async {
              final TextEditingController controller = TextEditingController();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('addBlockRule'.tr),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'enterBlockedWord'.tr,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            _controller.addBlock(controller.text);
                          }
                          Navigator.pop(context);
                        },
                        child: Text('ok'.tr),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<SettingController>(
            builder: (_) => ListView.builder(
                  itemCount: _controller.blockList.length + 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _controller.blockList.length) {
                      return const Divider();
                    }
                    if (index == _controller.blockList.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Text('blockInfo'.tr),
                      );
                    }
                    return ListTile(
                      title: Text(_controller.blockList[index]),
                      trailing: IconButton(
                        onPressed: () {
                          _controller.removeBlock(index);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    );
                  },
                )),
      ),
    );
  }
}
