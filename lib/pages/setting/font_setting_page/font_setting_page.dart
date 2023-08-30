import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:flutter_rss_reader/utils/font_manager.dart';
import 'package:get/get.dart';

class FontSettingPage extends StatelessWidget {
  FontSettingPage({super.key});
  final _controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('globalFont'.tr),
        actions: [
          // 添加字体
          IconButton(
            onPressed: () async {
              // 从本地文件导入字体
              await loadLocalFont();
              // 重新初始化字体名称列表
              await _controller.fontList();
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<SettingController>(
          builder: (_) => ListView.builder(
            itemCount: _controller.fontNameList.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return RadioListTile(
                  value: '默认字体',
                  groupValue: _controller.themeFont,
                  title: Text(
                    'defaultFont'.tr,
                    style: const TextStyle(fontFamily: '默认字体'),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      _controller.changeThemeFont(value);
                    }
                  },
                );
              }
              if (index == _controller.fontNameList.length + 1) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Text(
                        'fontInfo'.tr,
                      ),
                    ),
                  ],
                );
              }
              return RadioListTile(
                value: _controller.fontNameList[index - 1],
                groupValue: _controller.themeFont,
                title: Text(
                  _controller.fontNameList[index - 1].split('.').first,
                  style: TextStyle(
                      fontFamily: _controller.fontNameList[index - 1]),
                ),
                onChanged: (value) {
                  if (value != null) {
                    _controller.changeThemeFont(value);
                  }
                },
                secondary: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('删除确认'),
                        content: Text(
                          '确认删除字体：${_controller.fontNameList[index - 1]}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_controller.themeFont ==
                                  _controller.fontNameList[index - 1]) {
                                _controller.changeThemeFont('思源黑体');
                              }
                              // 删除字体
                              await deleteFont(
                                  _controller.fontNameList[index - 1]);
                              // 重新初始化字体名称列表
                              await _controller.fontList();
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
