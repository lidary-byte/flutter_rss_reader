import 'dart:convert';

import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/models/parse_help_bean.dart';

class BuiltInFeedBean {
  String? text;
  String? url;
  String? categorie;
  // 该数据源是否已存在
  // bool? isExit;
  ParseStatus? parseStatus;
  Feed? feed;

  BuiltInFeedBean({this.text, this.url, this.categorie});

  BuiltInFeedBean.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    url = json['url'];
    categorie = json['categorie'];
    feed = Feed.isExistSync(url!);
    // isExit = feed != null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['url'] = url;
    data['categorie'] = categorie;
    // data['isExit'] = isExit;
    return data;
  }

  static List<BuiltInFeedBean> fromJsonList(String str) =>
      List<BuiltInFeedBean>.from(
          json.decode(str).map((x) => BuiltInFeedBean.fromJson(x)));

  static String toJsonString(List<BuiltInFeedBean> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
