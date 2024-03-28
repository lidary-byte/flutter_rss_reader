import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension StringTimeUtil on String? {
  String calculateTimeDifference() {
    if (this == null) {
      return '';
    }

    // 解析给定格式的日期时间字符串
    DateTime dateTime = DateTime.parse(this!);

    // 格式化日期时间
    String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
    final now = DateTime.now();
    final difference = now.difference(DateTime.parse(formattedDateTime));
    if (difference.inDays > 6) {
      return formattedDateTime; // 超过6天显示具体日期
    } else if (difference.inDays > 0) {
      return 'daysAgo'.trArgs(['${difference.inDays}']);
    } else if (difference.inHours > 0) {
      return 'hoursAgo'.trArgs(['${difference.inHours}']);
    } else if (difference.inMinutes > 0) {
      return 'minuteAgo'.trArgs(['${difference.inMinutes}']);
    } else {
      return 'justNow'.tr;
    }
  }
}
