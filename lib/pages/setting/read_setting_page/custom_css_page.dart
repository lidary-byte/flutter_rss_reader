import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/pages/setting/read_setting_page/read_controller.dart';
import 'package:get/get.dart';

class CustomCssPage extends StatelessWidget {
  CustomCssPage({super.key});
  final _controller = Get.put(ReadController());

  final TextEditingController _customCssController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('customCSS'.tr),
      ),
      body: SafeArea(
        child: GetBuilder<ReadController>(builder: (_) {
          _customCssController.text = _controller.customCss;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            children: [
              TextFormField(
                controller: _customCssController,
                expands: false,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: 'enterCSSCode'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // 从剪贴板获取，光标移到末尾
                      Clipboard.getData('text/plain').then((value) {
                        if (value != null) {
                          _customCssController.text = value.text!;
                          _customCssController.selection =
                              TextSelection.fromPosition(
                                  TextPosition(offset: value.text!.length));
                        }
                      });
                    },
                    child: Text('paste'.tr),
                  ),
                  const SizedBox(width: 24),
                  TextButton(
                    onPressed: () async {
                      await _controller
                          .changeCustomCss(_customCssController.text);

                      Navigator.pop(context);
                    },
                    child: Text('save'.tr),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
