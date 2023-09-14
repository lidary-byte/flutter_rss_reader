import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:isar/isar.dart';

part 'feed_bean.g.dart';

@Collection()
class FeedBean {
  Id id = Isar.autoIncrement;

  String name;
  String? description;
  String? url;
  String? category;
  String? iconUrl;
  @Ignore()
  List<RssItemBean>? item;

  // 未读数量
  int? unReadCount = 0;
  bool fullText = false; // 是否全文
  int openType = 0; // 打开方式：0-阅读器 1-内置标签页 2-系统浏览器

  FeedBean(
      {required this.name,
      this.url,
      this.description,
      this.iconUrl,
      this.category,
      this.unReadCount,
      this.item});
}
