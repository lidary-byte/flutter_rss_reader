import 'package:flutter_rss_reader/models/feed.dart';

class ParseHelpBean {
  ParseStatus? parseStatus;
  String? url;
  Feed? feed;
  ParseHelpBean({this.parseStatus, this.url, this.feed});
}

enum ParseStatus { loading, success, isExist, error }
