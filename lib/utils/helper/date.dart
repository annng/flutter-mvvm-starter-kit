import 'package:intl/intl.dart';

class DateUtil {
  String getCurrentDate(String formatted) {
    DateTime now = DateTime.now();
    return DateFormat(formatted).format(now);
  }

  String setFormatDate(DateTime time, String formatted) {
    return DateFormat(formatted).format(time);
  }
}
