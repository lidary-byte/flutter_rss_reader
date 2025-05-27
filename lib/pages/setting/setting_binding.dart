import 'package:flutter_rss_reader/pages/setting/setting_controller.dart';
import 'package:get/get.dart';

class SettingBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => SettingController())];
}
