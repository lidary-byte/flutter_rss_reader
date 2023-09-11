import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/feed_category_bean.dart';
import 'package:flutter_rss_reader/utils/web_feed_parse_util.dart';
import 'package:opml/opml.dart';

/// 解析 OPML 文件
/// 返回 [Feed] 解析失败的数量
Future<int> parseOpml(FilePickerResult result) async {
  final file = result.files.first;
  /* 读取文件内容，转为字符串 */
  final File opmlFile = File(file.path!);
  final String opmlString = await opmlFile.readAsString();
  int failCount = 0;
  final opml = OpmlDocument.parse(opmlString);
  await Future.wait(
    opml.body.map(
      (category) async {
        final String? categoryName = category.title;
        await Future.wait(
          category.children!.map(
            (opmlOutline) async {
              if (FeedBean.isExistSync(opmlOutline.xmlUrl!) == null) {
                FeedBean? feed = await parseFeed(opmlOutline.xmlUrl!,
                    categoryName: categoryName, feedName: opmlOutline.title!);
                if (feed != null) {
                  await feed.insert();
                } else {
                  failCount++;
                }
              }
            },
          ),
        );
      },
    ),
  );
  return failCount;
}

/// 导出 OPML 文件
Future<String> exportOpmlBase() async {
  final List<FeedCategoryBean> feedMap =
      await FeedBean.groupByCategoryFeedList();
  final head = OpmlHeadBuilder().title('Feeds From MeRead').build();

  final body = <OpmlOutline>[];
  feedMap.forEach((element) {
    var c = OpmlOutlineBuilder()
        .title(element.category ?? '')
        .text(element.category ?? '');
    element.feeds?.forEach((feed) {
      c.addChild(OpmlOutlineBuilder()
          .title(feed.name)
          .text(feed.name)
          .type('rss')
          .xmlUrl(feed.url ?? '')
          .build());
    });
  });

  final opml = OpmlDocument(
    head: head,
    body: body,
  );
  return opml.toXmlString(pretty: true);
}
