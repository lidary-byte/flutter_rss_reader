import 'package:flutter_rss_reader/language/app_en.dart';
import 'package:flutter_rss_reader/language/app_zh.dart';
import 'package:get/get.dart';

class Message extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'zh': zh, 'en': en};
}
