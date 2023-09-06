import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
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
            onPressed: _addBlock,
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<SettingController>(
            id: 'block_list',
            builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Wrap(
                        spacing: 12.0,
                        children: _controller.blockList
                            .map((e) => Chip(
                                  label: Text(e),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  deleteIcon: const Icon(Icons.close_outlined),
                                  deleteIconColor: Colors.red,
                                  onDeleted: () => _controller.removeBlock(e),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('blockInfo'.tr),
                    )
                  ],
                )),
      ),
    );
  }

  void _addBlock() async {
    final TextEditingController controller = TextEditingController();
    Get.dialog(Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
            type: MaterialType.transparency,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      decoration: ShapeDecoration(
                          color: Get.theme.appBarTheme.backgroundColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ))),
                      margin: const EdgeInsets.all(12.0),
                      child: Column(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            child: Center(
                                child: Text('addBlockRule'.tr,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    )))),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, bottom: 16),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                hintText: 'enterBlockedWord'.tr,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)))),
                          ),
                        ),
                        const Divider(height: 0.1),
                        SizedBox(
                            height: 48,
                            child: Row(
                              children: [
                                Expanded(
                                    // InkWell直接用的话会出现按下时的水波纹效果失效
                                    child: Material(
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8)),
                                  child: InkWell(
                                    child: Ink(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'cancel'.tr,
                                          style: TextStyle(
                                              color: HexColor('#8D8D8D')),
                                        ),
                                      ),
                                    ),
                                    onTap: () => Get.back(),
                                  ),
                                )),
                                const VerticalDivider(width: 0.1),
                                Expanded(
                                    child: Material(
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(8)),
                                  child: InkWell(
                                    child: Ink(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text('ok'.tr),
                                      ),
                                    ),
                                    onTap: () {
                                      if (controller.text.isNotEmpty) {
                                        _controller.addBlock(controller.text);
                                      }
                                      Get.back();
                                    },
                                  ),
                                ))
                              ],
                            ))
                      ]))
                ]))));
  }
}
