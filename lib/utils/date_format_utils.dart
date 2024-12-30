import 'package:intl/intl.dart';

class DateFormatUtils {
  static const String DD_MM_YYYY = "dd/MM/yyyy";
  static const String DD_MM_YYYY_hh_mm_ss = "yyyy-MM-dd hh:mm:ss";
  static const String hh_mm_a = "hh:mm a";
  static const String d_MMM = "d\nMMM";

  static String formatDateFromTimeStamp(int timestamp) {
    return DateFormat('MM/dd/yyyy\nhh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  static String formatDateFromString(
    String dateTime, {
    String format = 'MM/dd/yyyy\nhh:mm a',
    bool isUtc = false,
  }) {
    if (isUtc) {
      return DateFormat(format).format(DateTime.parse(dateTime).toLocal());
    }

    return DateFormat(format).format(DateTime.parse(dateTime));
  }
}
