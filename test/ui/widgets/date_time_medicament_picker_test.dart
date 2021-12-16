import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicaments_app/ui/widgets/date_time_medicament_picker.dart';

void main() {
  group('DateTimeMedicamentPicker Widget', () {
    testWidgets('renders', (WidgetTester tester) async {
      String hours = '18:00';

      TextEditingController _textEditingController = TextEditingController(text: hours);

      final dateTimeMedicamentPicker = MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: Column(
            children: [
              DateTimeMedicamentPicker(timePickerController: _textEditingController)
            ],
          ),
        ),
      );

      await tester.pumpWidget(dateTimeMedicamentPicker);
      expect(find.byWidget(dateTimeMedicamentPicker), findsOneWidget);
    });
  });
}
