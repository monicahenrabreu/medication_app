import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/widgets/medicament_calendar_marker.dart';

void main() {
  group('MedicamentCalendarMarker Widget', () {
    Widget medicamentCalendarMarkerTestableWidget({required Widget child}) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('Both medicaments successfully tooked',
        (WidgetTester tester) async {
      DateTime now = DateTime.now();

      final medicamentCalendarMarker = medicamentCalendarMarkerTestableWidget(
          child: MedicamentCalendarMarker(
        date: now.subtract(const Duration(hours: 1)),
        medicaments: [
          Medicament(
              id: '1',
              title: 'Bruffen',
              dateOnlyOneTime: now,
              hour: now,
              tookMedicament: true),
          Medicament(
              id: '2',
              title: 'Benouron',
              dateOnlyOneTime: now,
              hour: now,
              tookMedicament: true),
        ],
      ));

      await tester.pumpWidget(medicamentCalendarMarker);

      final finder = find.byWidgetPredicate(
          (widget) => (widget is Icon && (widget).icon == Icons.check));
      expect(finder, findsOneWidget);
    });

    testWidgets('Both medicaments unsuccessfully tooked',
        (WidgetTester tester) async {
      DateTime now = DateTime.now();

      final medicamentCalendarMarker = medicamentCalendarMarkerTestableWidget(
          child: MedicamentCalendarMarker(
        date: now,
        medicaments: [
          Medicament(
              id: '1',
              title: 'Bruffen',
              dateOnlyOneTime: now,
              hour: now,
              tookMedicament: false),
          Medicament(
              id: '2',
              title: 'Benouron',
              dateOnlyOneTime: now,
              hour: now,
              tookMedicament: true),
        ],
      ));

      await tester.pumpWidget(medicamentCalendarMarker);

      final finder = find.byWidgetPredicate(
          (widget) => (widget is Icon && (widget).icon == Icons.add));
      expect(finder, findsOneWidget);
    });
  });
}
