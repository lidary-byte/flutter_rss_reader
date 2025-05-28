import 'package:flutter_rss_reader/pages/read/read_controller.dart';
import 'package:get/get.dart';

class ReadBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => ReadController())];
}
