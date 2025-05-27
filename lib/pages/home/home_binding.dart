import 'package:flutter_rss_reader/pages/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => HomeController())];
}
