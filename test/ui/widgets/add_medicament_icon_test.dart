 import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicaments_app/ui/widgets/add_medicament_icon.dart';

void main() {
  group('AddMedicamentIcon Widget', () {
    testWidgets('button clicked',
        (WidgetTester tester) async {
      final addMedicamentIcon = MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return const AddMedicamentIcon();
            },
          ),
        ),
      );

      await tester.pumpWidget(addMedicamentIcon);
      var icon = find.byIcon(Icons.add);
      await tester.press(icon);
    });
  });
}
