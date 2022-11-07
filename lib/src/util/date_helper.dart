extension DateFormater on DateTime {
  String get dayMonthHourMinute {
    return '$day.$month $hour:$minute';
  }
}
