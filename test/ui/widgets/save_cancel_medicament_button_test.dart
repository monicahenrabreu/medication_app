import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/ui/widgets/save_cancel_medicament_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final saveCancelMedicamentButton = MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Column(
      children: [SaveCancelMedicamentButton(() => {}, () => {})],
    ),
  );

  group('SaveCancelMedicamentButton Widget', () {
    testWidgets('cancel button clicked', (WidgetTester tester) async {
      await tester.pumpWidget(saveCancelMedicamentButton);
      expect(find.byWidget(saveCancelMedicamentButton), findsOneWidget);
      var cancelButton = find.text('Cancel');
      expect(cancelButton, findsOneWidget);
      await tester.press(cancelButton);
    });

    testWidgets('save button clicked', (WidgetTester tester) async {
      await tester.pumpWidget(saveCancelMedicamentButton);
      expect(find.byWidget(saveCancelMedicamentButton), findsOneWidget);
      var saveButton = find.text('Save');
      expect(saveButton, findsOneWidget);
      await tester.press(saveButton);
    });
  });
}
