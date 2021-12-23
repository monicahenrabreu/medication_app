import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/ui/widgets/days_choosed_medicament.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockCalendarBloc extends MockBloc<CalendarEvent, CalendarState>
    implements CalendarBloc {}

class CalendarStateFake extends Fake implements CalendarState {}

class CalendarEventFake extends Fake implements CalendarEvent {}

void main() {
  final daysChoosedMedicamentWidget = MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Column(
      children: const [DaysChoosedMedicament()],
    ),
  );

  group('DaysChoosedMedicament', () {
    setUpAll(() {
      registerFallbackValue(CalendarStateFake());
      registerFallbackValue(CalendarEventFake());
    });

    testWidgets('renders', (WidgetTester tester) async {
      final daysChoosedMedicament = MultiBlocProvider(
        providers: [
          BlocProvider<CalendarBloc>(
            lazy: false,
            create: (context) => CalendarBloc(),
          ),
        ],
        child: daysChoosedMedicamentWidget,
      );

      await tester.pumpWidget(daysChoosedMedicament);
      expect(find.byWidget(daysChoosedMedicament), findsOneWidget);
    });
  });
}
