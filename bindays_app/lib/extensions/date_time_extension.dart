// External Imports
import "package:intl/intl.dart";

extension DateTimeExtension on DateTime {
  String toLongDateString() {
    return "${DateFormat(DateFormat.WEEKDAY).format(this)}, $day ${DateFormat(DateFormat.MONTH).format(this)}";
  }

  String daysUntilString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(year, month, day);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 1) {
      return '$difference days';
    } else {
      return '${difference.abs()} days ago';
    }
  }
}
