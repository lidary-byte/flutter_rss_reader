import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_rss_reader/bean/feed_bean.dart';

class ParseFeed {
  String? url;
  String? categoryName;
  SendPort? sendPort;
  RootIsolateToken? rootIsolateToken;
  ParseFeed(
      {this.url, this.categoryName, this.sendPort, this.rootIsolateToken});
}

class ParseFeedResult {
  String? url;
  FeedBean? feedBean;
  ParseFeedResult({this.url, this.feedBean});
}
