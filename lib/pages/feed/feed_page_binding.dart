import 'package:flutter_rss_reader/pages/feed/feed_page_controller.dart';
import 'package:get/get.dart';

class FeedPageBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => FeedPageController())];
}
