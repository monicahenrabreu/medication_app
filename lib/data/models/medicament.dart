import 'package:equatable/equatable.dart';

class Medicament extends Equatable {
  final String id;
  final String title;
  final DateTime hour;
  final DateTime? dateOnlyOneTime;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool tookMedicament;

  const Medicament(
      {required this.id,
      required this.title,
      required this.hour,
      this.dateOnlyOneTime,
      this.fromDate,
      this.toDate,
      this.tookMedicament = false});

  @override
  List<Object?> get props => [id, title, hour, dateOnlyOneTime, fromDate, toDate, tookMedicament];
}
