import 'package:flutter_rss_reader/pages/built_feed/built_feed_controller.dart';
import 'package:get/get.dart';

class BuiltFeedBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => BuiltFeedController())];
}
