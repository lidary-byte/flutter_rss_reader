import 'package:collection/collection.dart';
import 'package:flutter_rss_reader/bean/feed_category_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:isar/isar.dart';

part 'feed_bean.g.dart';

@Collection()
class FeedBean {
  Id id = Isar.autoIncrement;

  String name;
  String? description;
  String? url;
  String? category;

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
      this.category,
      this.unReadCount,
      this.item});

  /// 插入数据库
  /// 如果存在则取消
  Future<int?> insert() async {
    final feed = await isar.feedBeans.filter().urlEqualTo(url).findFirst();

    if (feed == null) {
      return await isar.writeTxn(() => isar.feedBeans.put(this));
    }
    return null;
  }

  /// 查询所有 item 按照发布时间倒序
  static Future<List<RssItemBean>> rssItems() async {
    return await isar.rssItemBeans.where().sortByPubDateDesc().findAll();
  }

  /// 根据 Feed 查询 item，按照发布时间倒序
  Future<List<RssItemBean>> rssItemsByFeeds() async {
    return await isar.rssItemBeans
        .filter()
        .feedIdEqualTo(id)
        .sortByPubDateDesc()
        .findAll();
  }

  /// 根据 Feed 查询 未读item，按照发布时间倒序
  Future<List<RssItemBean>> rssItemsByFeedsWithUnRead() async {
    return await isar.rssItemBeans
        .filter()
        .readEqualTo(false)
        .feedIdEqualTo(id)
        .sortByPubDateDesc()
        .findAll();
  }

  /// 根据 Feed 查询 添加到收藏的，按照发布时间倒序
  Future<List<RssItemBean>> rssItemsByFeedsWithFavorite() async {
    return await isar.rssItemBeans
        .filter()
        .favoriteEqualTo(true)
        .feedIdEqualTo(id)
        .sortByPubDateDesc()
        .findAll();
  }

  /// 根据 url 判断 Feed 是否已存在 同步方法
  static FeedBean? isExistSync(String url) {
    return isar.feedBeans.where().filter().urlEqualTo(url).findFirstSync();
  }

  /// 查询所有 Feed 并按分类分组
  static Future<List<FeedCategoryBean>> groupByCategoryFeedList() async {
    final List<FeedBean> feeds = await isar.feedBeans.where().findAll();
    return groupBy(feeds, (feed) => feed.category)
        .entries
        .map((entry) =>
            FeedCategoryBean(category: entry.key, feeds: entry.value))
        .toList();
  }

  /// 更新 Feed 下的内容
  Future<void> updateToDb() async {
    final List<RssItemBean> items =
        await isar.rssItemBeans.filter().feedIdEqualTo(id).findAll();
    for (var element in items) {
      element.feedName = name;
      element.updateToDb();
    }
    await isar.writeTxn(() => isar.feedBeans.put(this));
  }

  /// 删除 Feed
  Future<void> deleteFromDb() async {
    /* 删除订阅源 */
    await isar.writeTxn(() async {
      await isar.feedBeans.delete(id);
    });
    /* 删除该订阅源的所有文章 */
    await isar.rssItemBeans.filter().feedIdEqualTo(id).deleteAll();
  }

  ///  更新未读数量
  Future updateUnReadCount(int unReadCount) async {
    this.unReadCount = unReadCount;
    await isar.writeTxn(() => isar.feedBeans.put(this));
  }
}
