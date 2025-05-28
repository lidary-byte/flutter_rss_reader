import 'package:flutter_rss_reader/bean/feed_category_bean.dart';
import 'package:flutter_rss_reader/db/database_feed.dart';
import 'package:opml/opml.dart';

/// 导出 OPML 文件
Future<String> exportOpmlBase() async {
  final List<FeedCategoryBean> feedMap =
      await DatabaseFeed.groupByCategoryFeedList();
  final head = OpmlHeadBuilder().title('ARead').build();

  final body = <OpmlOutline>[];
  for (var element in feedMap) {
    final fees = element.feeds?.map(
      (feed) => OpmlOutlineBuilder()
          .title(feed.name)
          .text(feed.name)
          .type('rss')
          .xmlUrl(feed.url ?? '')
          .category(element.category ?? '')
          .build(),
    );
    body.addAll(fees ?? []);
  }

  final opml = OpmlDocument(head: head, body: body);
  return opml.toXmlString(pretty: true);
}
