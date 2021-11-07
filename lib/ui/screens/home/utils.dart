import 'dart:collection';
import 'package:medicaments_app/models/medicament_event.dart';
import 'package:table_calendar/table_calendar.dart';

/*
copy example from https://github.com/aleksanderwozniak/table_calendar/tree/master/example
 */

/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
LinkedHashMap kEvents = LinkedHashMap<DateTime, List<MedicamentEvent>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1,
        (index) => MedicamentEvent(
            title: 'Lorem ipsum | ${index + 1}',
            hour: DateTime.utc(
                kFirstDay.year, kFirstDay.month, item * 5, 12, 12, 0))))
  ..addAll({
    kToday: [
      MedicamentEvent(
          title: 'Medicament 1',
          hour: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, 12, 12, 0)),
      MedicamentEvent(
          title: 'Medicament 2',
          hour: DateTime.utc(kFirstDay.year, kFirstDay.month, 5, 12, 12, 0)),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

void addEvent(MedicamentEvent event, DateTime date) {
  List<MedicamentEvent> list = [event];

  Map<DateTime, List<MedicamentEvent>> map = {date: list};
  kEvents.addAll(map);
}

void addRangeOfEvents(
    MedicamentEvent event, DateTime fromDate, DateTime toDate) {
  List<MedicamentEvent> list = [event];
  DateTime date = fromDate;

  while (date.compareTo(toDate) <= 0) {
    Map<DateTime, List<MedicamentEvent>> map = {date: list};
    kEvents.addAll(map);

    date = date.add(const Duration(days: 1));
  }
}
