import 'package:flutter_rss_reader/pages/subscription/subscription_controller.dart';
import 'package:get/get.dart';

class SubscriptionBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => SubscriptionController())];
}
