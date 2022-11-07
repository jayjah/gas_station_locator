extension DateFormater on DateTime {
  String get toHourMinuteDayMonth {
    return '$hour:$minute $day.$month';
  }
}
