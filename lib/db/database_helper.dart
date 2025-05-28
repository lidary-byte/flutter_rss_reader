import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// 程序开始时初始化一次
Future initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([FeedBeanSchema, RssItemBeanSchema], directory: dir.path);
}

Future<Isar> get isarInstance async {
  var isarInstance = Isar.getInstance();
  if (isarInstance == null) {
    final dir = await getApplicationDocumentsDirectory();
    isarInstance = await Isar.open([
      FeedBeanSchema,
      RssItemBeanSchema,
    ], directory: dir.path);
  }
  return isarInstance;
}
