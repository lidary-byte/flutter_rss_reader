import 'package:isar/isar.dart';

part 'rss_item_bean.g.dart';

@Collection()
class RssItemBean {
  Id id = Isar.autoIncrement;
  int feedId; // 订阅源 ID
  String feedName;
  String? title;
  @Index()
  String? link;
  String? description;
  String? shortDescription;
  String? content;
  String? pubDate; // 发布时间
  String? author; // 作者
  String? cover; //文章封面
  String? cacheContent; //原文content 进行数据缓存
  bool read = false; // 是否已读
  bool favorite = false; // 是否已收藏
  bool fullText = false; // 是否全文
  int openType = 0; // 打开方式：0阅读器 1内置标签页 2系统浏览器

  RssItemBean({
    required this.feedId,
    required this.feedName,
    this.title,
    this.link,
    this.description,
    this.shortDescription,
    this.pubDate,
    this.author,
    this.cover,
    this.content,
  });
}
