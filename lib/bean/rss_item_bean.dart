import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/webfeed/domain/media/media.dart';
import 'package:isar/isar.dart';

part 'rss_item_bean.g.dart';

@Collection()
class RssItemBean {
  Id id = Isar.autoIncrement;
  int feedId; // 订阅源 ID
  String feedName;
  String? title;
  String? link;
  String? description;
  DateTime? pubDate; // 发布时间
  String? author; // 作者
  @Ignore()
  Media? media;
  String? cacheContent; //原文content 进行数据缓存
  bool read = false; // 是否已读
  bool favorite = false; // 是否已收藏
  bool fullText = false; // 是否全文
  int openType = 0; // 打开方式：0阅读器 1内置标签页 2系统浏览器

  RssItemBean(
      {required this.feedId,
      required this.feedName,
      this.title,
      this.link,
      this.description,
      this.pubDate,
      this.author,
      this.media});

  /// 插入数据库
  /// 如果存在则取消
  void insert() async {
    final rssItem =
        await isar.rssItemBeans.filter().linkEqualTo(link).findFirst();

    if (rssItem == null) {
      await isar.writeTxn(() => isar.rssItemBeans.put(this));
    }
  }

  /// 查询所有 Post，按照发布时间倒序
  static Future<List<RssItemBean>> getAll() async {
    return await isar.rssItemBeans.where().sortByPubDateDesc().findAll();
  }

  /// 根据 List<Feed> 查询所有 Post，按照发布时间倒序
  // static Future<List<RssItemBean>> getAllByFeeds(List<FeedBean> feeds) async {
  //   final List<int> feedIds = [];
  //   for (var feed in feeds) {
  //     feedIds.add(feed.id!);
  //   }
  //   final posts = await getAll();
  //   return posts.where((post) => feedIds.contains(post.feedId)).toList();
  // }

  /// 更新已经存在的item
  Future<void> updateToDb() async {
    await isar.writeTxn(() async {
      await isar.rssItemBeans.put(this);
    });
  }

  /// 更改阅读状态
  void changeReadStatus(bool read) async {
    if (this.read == read) {
      return;
    }
    this.read = read;
    await updateToDb();
    final unReadCount =
        await isar.rssItemBeans.filter().readEqualTo(false).count();
    final feed = await isar.feedBeans.filter().idEqualTo(feedId).findFirst();
    await feed?.updateUnReadCount(unReadCount);
  }

  /// 标记所有未读 item 为已读
  static Future<void> markAllRead(List<RssItemBean> rssItems) async {
    for (RssItemBean rssItem in rssItems) {
      rssItem.changeReadStatus(true);
    }
  }

  /// 改变收藏状态
  void changeFavorite() async {
    favorite = !favorite;
    await updateToDb();
  }
}
