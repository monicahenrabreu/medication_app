enum TookPill { took, didNotTook, snooze }

class Medicament {
  final String title;
  final DateTime hour;
  final TookPill? tookPill;

  const Medicament({required this.title, required this.hour, this.tookPill});
}
