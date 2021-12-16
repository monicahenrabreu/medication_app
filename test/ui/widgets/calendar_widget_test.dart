import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/bloc/calendar/bloc.dart';
import 'package:medicaments_app/ui/widgets/calendar_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCalendarBloc extends MockBloc<CalendarEvent, CalendarState>
    implements CalendarBloc {}

class FakeCalendarState extends Mock implements CalendarState {}

class FakeCalendarEvent extends Mock implements CalendarEvent {}

void main() {
  group('CalendarWidget', () {
    setUpAll(() {
      registerFallbackValue(FakeCalendarState());
      registerFallbackValue(FakeCalendarEvent());
    });

    testWidgets('renders', (WidgetTester tester) async {
      final calendar = MultiBlocProvider(
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
                return const CalendarWidget();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(calendar);
      expect(find.byWidget(calendar), findsOneWidget);
    });
  });
}
