import 'package:intl/intl.dart';

class UsefulFunction {
  static String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  static String getDate(DateTime date) {
    return DateFormat('EEEE, MMM dd yyyy').format(date);
  }

  static String getHour(DateTime date) {
    return date.hour.toString();
  }

  static String getHourAndMinute(DateTime date) {
    return DateFormat('hh:mm').format(date);
  }

  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
}
