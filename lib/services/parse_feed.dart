import 'package:flutter_rss_reader/bean/feed_bean.dart';

class ParseFeed {
  String? url;
  String? categoryName;
  ParseFeed({this.url, this.categoryName});
}

class ParseFeedResult {
  String? url;
  FeedBean? feedBean;
  ParseFeedResult({this.url, this.feedBean});
}
