import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/built_in_feed_bean.dart';
import 'package:flutter_rss_reader/models/parse_help_bean.dart';
import 'package:flutter_rss_reader/widgets/button.dart';
import 'package:get/get.dart';

/// feed解析时状态按钮
// ignore: must_be_immutable
class FeedParseStatusWidget extends StatelessWidget {
  BuiltInFeedBean? item;
  VoidCallback? onImport;
  VoidCallback? onError;

  FeedParseStatusWidget({super.key, this.item, this.onImport, this.onError});

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const SizedBox();
    }

    if (item!.feed == null) {
      if (item!.parseStatus == ParseStatus.error) {
        return Button(
            text: 'retry'.tr, backgroundColor: Colors.red, onTap: onError);
      } else if (item!.parseStatus == ParseStatus.loading) {
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        return Button(text: 'import'.tr, onTap: onImport);
      }
    } else {
      return Icon(Icons.check, color: Get.theme.colorScheme.primary);
    }
  }
}
