import 'package:flutter_rss_reader/models/feed.dart';

class ParseHelpBean {
  ParseStatus? parseStatus;
  Feed? feed;
  String? url;
  String? categorie;
  ParseHelpBean({this.parseStatus, this.categorie, this.url, this.feed});
}

enum ParseStatus { loading, success, isExist, error }
