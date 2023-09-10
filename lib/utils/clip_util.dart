import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/widgets/toast.dart';
import 'package:get/get.dart';

class ClipUtil {
  /// 设置内容到剪贴板
  static void setClipboardData(String? content) {
    if (content != null && content.isBlank == false) {
      Clipboard.setData(ClipboardData(text: content));
      toast('copySuccess'.tr);
    }
  }

  /// 获取剪贴板内容
  static Future<String?> getClipboardData() async {
    return (await Clipboard.getData(Clipboard.kTextPlain))?.text;
  }
}
