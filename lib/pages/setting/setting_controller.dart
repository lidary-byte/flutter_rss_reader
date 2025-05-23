import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:flutter_rss_reader/services/parse_feed_services.dart';
import 'package:flutter_rss_reader/utils/opml_util.dart';
import 'package:flutter_rss_reader/widgets/toast.dart';
import 'package:get/get.dart';
// import 'package:shared_storage/shared_storage.dart';

class SettingController extends GetxController {
  final List<String> blockList = prefs.getStringList('blockList') ?? [];

  // 导入 OPML 文件
  void importOPML() async {
    // 打开文件选择器
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    var path = result?.files.firstOrNull?.path;
    if (path != null && path.isBlank == false && (path.endsWith(".opml"))) {
      toast('startBackgroundImport'.tr);
      Get.find<ParseFeedServices>().parseFeed(path);
      // toast(failCount == 0
      //     ? 'importSuccess'.tr
      //     : 'importFailedForFeeds'.trArgs(['$failCount']));
    }
  }

  // 导出 OPML 文件
  Future<void> exportOPML() async {
    // final String successText = 'shareOPMLFile'.tr;
    String opmlStr = await exportOpmlBase();

    // final Uri? selectedDocumentUris = await openDocumentTree(
    //   persistablePermission: true,
    //   grantWritePermission: true,
    // );
    // if (selectedDocumentUris.isBlank == true) {
    //   return;
    // }

    // final DocumentFile? file = await createFileAsBytes(selectedDocumentUris!,
    //     mimeType: '*/*',
    //     displayName: 'ARead-${DateTime.now()}.opml',
    //     bytes: Uint8List.fromList(utf8.encode(opmlStr)));
    // if (file != null) {
    //   toast('exportSuccess'.tr);
    // }
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
