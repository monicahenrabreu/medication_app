import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicaments_app/ui/widgets/text_medicament_form_field.dart';

void main() {
  group('TextMedicamentFormField Widget', () {
    TextEditingController _controllerName =
        TextEditingController(text: 'hello');

    final textMedicamentFormField = MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Column(
          children: [
            TextMedicamentFormField(controllerName: _controllerName),
          ],
        ),
      ),
    );

    testWidgets('renders', (WidgetTester tester) async {
      await tester.pumpWidget(textMedicamentFormField);
      expect(find.byWidget(textMedicamentFormField), findsOneWidget);

      var textFind = find.text('hello');
      expect(textFind, findsOneWidget);
    });
  });
}
