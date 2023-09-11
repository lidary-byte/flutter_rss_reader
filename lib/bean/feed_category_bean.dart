import 'package:flutter_rss_reader/bean/feed_bean.dart';

class FeedCategoryBean {
  String? category;
  List<FeedBean>? feeds;
  FeedCategoryBean({this.category, this.feeds});
}
