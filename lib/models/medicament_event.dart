enum TookPill { took, didNotTook, snooze }

class MedicamentEvent {
  final String title;
  final DateTime hour;
  final TookPill? tookPill;

  const MedicamentEvent(
      {required this.title, required this.hour, this.tookPill});
}
