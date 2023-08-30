import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/models/feed.dart';
import 'package:flutter_rss_reader/utils/parse.dart';
import 'package:flutter_rss_reader/widgets/snackbar.dart';
import 'package:get/get.dart';

class AddFeedController extends GetxController {
  final TextEditingController _urlController = TextEditingController();
  TextEditingController get urlController => _urlController;

  Feed? _feed;
  Feed? get feed => _feed;

  ///  从剪贴板获取订阅源地址，光标移到末尾
  void clipBoard() async {
    final value = (await Clipboard.getData('text/plain'))?.text;
    if (value != null && value.isBlank == false) {
      _urlController.text = value;
      _urlController.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    }
  }

  void parse() async {
    if (await Feed.isExist(_urlController.text)) {
      showSnackBar(content: 'feedAlreadyExists'.tr);
      return;
    }

    _feed = await parseFeed(_urlController.text);
    if (_feed == null) {
      showSnackBar(content: 'unableToParseFeed'.tr);
      return;
    }
    update(['feed']);
  }
}
