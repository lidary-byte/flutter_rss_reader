import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/provider/read_page_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomCssPage extends StatefulWidget {
  const CustomCssPage({Key? key}) : super(key: key);

  @override
  CustomCssPageState createState() => CustomCssPageState();
}

class CustomCssPageState extends State<CustomCssPage> {
  final TextEditingController _customCssController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customCssController.text = context.read<ReadPageProvider>().customCss;
  }

  @override
  Widget build(BuildContext context) {
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
                    await context
                        .read<ReadPageProvider>()
                        .changeCustomCss(_customCssController.text);
                    if (!mounted) return;
                    Navigator.pop(context);
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
}
