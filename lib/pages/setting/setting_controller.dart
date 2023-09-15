import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/utils/opml_util.dart';
import 'package:flutter_rss_reader/widgets/toast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingController extends GetxController {
  final List<String> blockList = prefs.getStringList('blockList') ?? [];

  // 导入 OPML 文件
  void importOPML() async {
    // 打开文件选择器
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['opml', 'xml'],
    );
    if (result != null) {
      toast('startBackgroundImport'.tr);
      final int failCount = await parseOpml(result);
      toast(failCount == 0
          ? 'importSuccess'.tr
          : 'importFailedForFeeds'.trArgs(['$failCount']));
    }
  }

  // 导出 OPML 文件
  Future<void> exportOPML() async {
    final String successText = 'shareOPMLFile'.tr;
    String opmlStr = await exportOpmlBase();
    // opmlStr 字符串写入 feeds.opml 文件并分享，分享后删除文件
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/feeds-from-aReader.xml');
    await file.writeAsString(opmlStr);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: successText,
    ).then((value) {
      if (value.status == ShareResultStatus.success) {
        toast('exportSuccess'.tr);
      }
    });
    await file.delete();
  }

  void removeBlock(String item) async {
    blockList.remove(item);
    await prefs.setStringList('blockList', blockList);
    update(['block_list']);
  }

  void addBlock(String text) async {
    blockList.add(text);
    await prefs.setStringList('blockList', blockList);
    update(['block_list']);
  }
}
