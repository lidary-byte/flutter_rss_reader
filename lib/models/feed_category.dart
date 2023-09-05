import 'package:flutter_rss_reader/models/feed.dart';

class FeedCategory {
  String category;
  List<Feed> feeds;

  FeedCategory({
    required this.category,
    required this.feeds,
  });
}
