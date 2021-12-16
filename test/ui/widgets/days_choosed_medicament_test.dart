import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicaments_app/ui/widgets/days_choosed_medicament.dart';
import 'package:mocktail/mocktail.dart';

class MockCalendarBloc extends MockBloc<CalendarEvent, CalendarState>
    implements CalendarBloc {}

class CalendarStateFake extends Fake implements CalendarState {}

class CalendarEventFake extends Fake implements CalendarEvent {}

void main() {
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
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const DaysChoosedMedicament();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(daysChoosedMedicament);
      expect(find.byWidget(daysChoosedMedicament), findsOneWidget);
    });
  });
}
