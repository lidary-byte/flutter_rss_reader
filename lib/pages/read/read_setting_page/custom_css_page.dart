import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:get/get.dart';

class CustomCssPage extends StatelessWidget {
  CustomCssPage({super.key});
  final _controller = Get.find<ReadController>();

  final TextEditingController _customCssController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _customCssController.text = _controller.customCss;

    return Scaffold(
      appBar: AppBar(
        title: Text('customCSS'.tr),
      ),
      body: SafeArea(
        child: ListView(
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
                  onPressed: _toClipboard,
                  child: Text('paste'.tr),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () async {
                    _controller.changeCustomCss(_customCssController.text);
                    Get.back();
                  },
                  child: Text('save'.tr),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _toClipboard() async {
    // 从剪贴板获取，光标移到末尾
    final text = (await Clipboard.getData('text/plain'))?.text;
    if (text != null && text.isBlank == false) {
      _customCssController.text = text;
      _customCssController.selection =
          TextSelection.fromPosition(TextPosition(offset: text.length));
    }
  }
}
