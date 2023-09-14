import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/database/database_helper.dart';
import 'package:isar/isar.dart';
import 'package:flutter_rss_reader/database/database_feed.dart';

extension DatabaseRssItem on RssItemBean {
  /// 插入数据库
  /// 如果存在则取消
  void insert() async {
    final isar = await isarInstance;
    final rssItem =
        await isar.rssItemBeans.filter().linkEqualTo(link).findFirst();

    if (rssItem == null) {
      await isar.writeTxn(() => isar.rssItemBeans.put(this));
    }
  }

  /// 查询所有 Post，按照发布时间倒序
  static Future<List<RssItemBean>> getAll() async {
    final isar = await isarInstance;
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
    final isar = await isarInstance;
    await isar.writeTxn(() async {
      await isar.rssItemBeans.put(this);
    });
  }

  /// 更改阅读状态
  void changeReadStatus(bool read) async {
    if (this.read == read) {
      return;
    }
    final isar = await isarInstance;
    this.read = read;
    await updateToDb();

    final unReadCount = await isar.rssItemBeans
        .filter()
        .readEqualTo(false)
        .feedIdEqualTo(feedId)
        .count();
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
