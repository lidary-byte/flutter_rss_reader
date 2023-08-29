import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/widgets/list_tile_group_title.dart';
import 'package:get/get.dart';

class EditFeedPage extends StatefulWidget {
  const EditFeedPage({Key? key, required this.feed}) : super(key: key);

  final Feed feed;

  @override
  EditFeedPageState createState() => EditFeedPageState();
}

class EditFeedPageState extends State<EditFeedPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.feed.url;
    _nameController.text = widget.feed.name;
    _categoryController.text = widget.feed.category;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> openTypeList = [
      'openInApp'.tr,
      'openInBuiltInTab'.tr,
      'openInSystemBrowser'.tr,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('editFeed'.tr),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _urlController,
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
                controller: _nameController,
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
                controller: _categoryController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'feedCategory'.tr,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SwitchListTile(
              value: widget.feed.fullText == 1,
              title: Text('fullText'.tr),
              onChanged: (bool value) {
                setState(() {
                  widget.feed.fullText = value ? 1 : 0;
                });
              },
            ),
            ListTileGroupTitle(title: 'postOpenWith'.tr),
            ...openTypeList.map(
              (e) {
                return RadioListTile(
                  value: openTypeList.indexOf(e),
                  groupValue: widget.feed.openType,
                  title: Text(e),
                  onChanged: (int? value) {
                    setState(() {
                      widget.feed.openType = value!;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 18),
            // 取消与保存
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel'.tr),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () async {
                    widget.feed.name = _nameController.text;
                    widget.feed.category = _categoryController.text;
                    // 如果 feed 不存在，添加 feed，否则更新 feed
                    if (await Feed.isExist(widget.feed.url)) {
                      await widget.feed.updateToDb();
                      await widget.feed.updatePostFeedName();
                      await widget.feed.updatePostsOpenType();
                    } else {
                      await widget.feed.insertToDb();
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text('save'.tr),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
