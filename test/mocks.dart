import 'package:medicaments_app/data/provider/base_medicament_provider.dart';
import 'package:medicaments_app/data/provider/base_notifications_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockMedicamentProvider extends Mock implements BaseMedicamentProvider {}

class MockNotificationsProvider extends Mock
    implements BaseNotificationsProvider {}
