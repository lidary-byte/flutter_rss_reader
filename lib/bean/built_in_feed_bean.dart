import 'dart:convert';

import 'package:flutter_rss_reader/bean/feed_bean.dart';
import 'package:flutter_rss_reader/database/database_feed.dart';

class BuiltInFeedBean {
  String? text;
  String? url;
  String? categorie;

  ParseStatus? parseStatus;
  FeedBean? feed;

  BuiltInFeedBean({this.text, this.url, this.categorie, this.parseStatus}) {
    DatabaseFeed.isExist(url!).then((value) => feed = value);
  }

  BuiltInFeedBean.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    url = json['url'];
    categorie = json['categorie'];
    DatabaseFeed.isExist(url!).then((value) => feed = value);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['url'] = url;
    data['categorie'] = categorie;
    return data;
  }

  static List<BuiltInFeedBean> fromJsonList(String str) =>
      List<BuiltInFeedBean>.from(
          json.decode(str).map((x) => BuiltInFeedBean.fromJson(x)));

  static String toJsonString(List<BuiltInFeedBean> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

enum ParseStatus { loading, error }
