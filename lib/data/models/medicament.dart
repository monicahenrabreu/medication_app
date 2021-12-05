class Medicament {
  final String id;
  final String title;
  final DateTime hour;
  final bool tookMedicament;

  const Medicament(
      {required this.id,
      required this.title,
      required this.hour,
      this.tookMedicament = false});
}
