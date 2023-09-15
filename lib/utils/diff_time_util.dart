import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DiffTimeUtil on DateTime? {
  String calculateTimeDifference() {
    if (this == null) {
      return '';
    }
    final now = DateTime.now();
    final difference = now.difference(this!);
    if (difference.inDays > 6) {
      return DateFormat('yyyy-MM-dd').format(this!); // 超过6天显示具体日期
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
