import 'package:flutter_rss_reader/models/feed.dart';

class BuiltInFeedBean {
  Result? result;

  BuiltInFeedBean({this.result});

  BuiltInFeedBean.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<Items>? items;

  Result({this.items});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? text;
  String? url;
  List<String>? categories;
  // 该数据源是否已存在
  bool? isExit;

  Items({this.text, this.url, this.categories});

  Items.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    url = json['url'];
    categories = json['categories'].cast<String>();
    isExit = url == null ? true : Feed.isExistSync(url!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['url'] = url;
    data['categories'] = categories;
    data['isExit'] = isExit;
    return data;
  }
}
