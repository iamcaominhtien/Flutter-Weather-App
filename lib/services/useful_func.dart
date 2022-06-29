import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsefulFunction {
  static String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  static String getDate(DateTime date) {
    return DateFormat('EEEE, MMM dd yyyy').format(date);
  }

  static String getOnlyDayNumber(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String getHour(DateTime date) {
    return date.hour.toString();
  }

  static String getHourAndMinute([DateTime? date, bool? hour24]) {
    if (date == null) {
      return DateFormat('${hour24 == true ? 'HH' : 'hh'}:mm')
          .format(DateTime.now());
    }
    return DateFormat('${hour24 == true ? 'HH' : 'hh'}:mm').format(date);
  }

  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static void pushReplacement(
      {required BuildContext context, required Widget page}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static showSnackBar(
      {required BuildContext context,
      required String message,
      int seconds = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
