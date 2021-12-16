import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/configs/constants.dart';
import 'package:medicaments_app/data/models/medicament.dart';
import 'package:medicaments_app/ui/widgets/date_and_hours.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateAndHours Widget', () {
    Widget dateAndHoursTestableWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Column(
          children: [child],
        ),
      );
    }

    testWidgets('renders - Only one day of Bruffen',
        (WidgetTester tester) async {
      DateTime now = DateTime.now();

      final dateAndHours = dateAndHoursTestableWidget(
          child: DateAndHours(
        medicament: Medicament(
            id: '1', title: 'Bruffen', dateOnlyOneTime: now, hour: now),
      ));

      await tester.pumpWidget(dateAndHours);
      expect(find.byWidget(dateAndHours), findsOneWidget);

      final dateFormat = DateFormat(Constants.dateFormat);
      final date = dateFormat.format(now);
      final hourFormat = DateFormat(Constants.hourFormat);
      final hour = hourFormat.format(now);

      expect(find.text('Only in ' + date + ' at ' + hour), findsOneWidget);
    });

    testWidgets('renders - Two days of Benouron', (WidgetTester tester) async {
      DateTime now = DateTime.now();
      DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

      final dateAndHours = dateAndHoursTestableWidget(
          child: DateAndHours(
        medicament: Medicament(
            id: '1',
            title: 'Benouron',
            fromDate: now,
            toDate: tomorrow,
            hour: now),
      ));

      await tester.pumpWidget(dateAndHours);
      expect(find.byWidget(dateAndHours), findsOneWidget);

      final dateFormat = DateFormat(Constants.dateFormat);
      final fromDate = dateFormat.format(now);
      final toDate = dateFormat.format(tomorrow);
      final hourFormat = DateFormat(Constants.hourFormat);
      final hour = hourFormat.format(now);

      expect(find.text('From ' + fromDate + ' to ' + toDate + ' at ' + hour),
          findsOneWidget);
    });
  });
}
