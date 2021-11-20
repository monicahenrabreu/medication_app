/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final calendarToday = DateTime.now();
final calendarFirstDay =
    DateTime(calendarToday.year, calendarToday.month - 3, calendarToday.day);
final calendarLastDay =
    DateTime(calendarToday.year, calendarToday.month + 3, calendarToday.day);
