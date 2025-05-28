import 'dart:convert';

import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/db/database_feed.dart';

class BuiltInFeedBean {
  String? text;
  String? url;

  ParseStatus? parseStatus;
  FeedBean? feed;

  BuiltInFeedBean({this.text, this.url, this.parseStatus}) {
    DatabaseFeed.isExist(url!).then((value) => feed = value);
  }

  BuiltInFeedBean.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    url = json['url'];
    DatabaseFeed.isExist(url!).then((value) => feed = value);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['url'] = url;
    return data;
  }

  static List<BuiltInFeedBean> fromJsonList(String str) =>
      List<BuiltInFeedBean>.from(
        json.decode(str).map((x) => BuiltInFeedBean.fromJson(x)),
      );

  static String toJsonString(List<BuiltInFeedBean> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

enum ParseStatus { loading, error }
