import 'package:intl/intl.dart';

class DateUtil {
  static String formatString(String str,
      [String format = 'yyyy-MM-dd HH:mm:ss']) {
    final date = DateTime.tryParse(str);
    return DateUtil.format(date, format);
  }

  static String format(DateTime? datetime,
      [String format = 'yyyy-MM-dd HH:mm:ss']) {
    if (datetime == null) return '';
    return DateFormat(format).format(datetime);
  }

  static String formatDuration(Duration duration, [String format = 'mm:ss']) {
    return DateFormat(format).format(DateTime(0, 0, duration.inDays,
        duration.inHours, duration.inMinutes, duration.inSeconds));
  }
}
