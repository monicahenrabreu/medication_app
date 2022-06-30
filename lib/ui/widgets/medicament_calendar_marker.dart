import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:medicaments_app/data/models/medicament.dart';

class MedicamentCalendarMarker extends StatefulWidget {
  final DateTime date;
  final List<Medicament> medicaments;

  const MedicamentCalendarMarker(
      {required this.date, required this.medicaments, Key? key})
      : super(key: key);

  @override
  State<MedicamentCalendarMarker> createState() =>
      _MedicamentCalendarMarkerState();
}

class _MedicamentCalendarMarkerState extends State<MedicamentCalendarMarker> {
  @override
  Widget build(BuildContext context) {
    bool took = true;

    for (Medicament medicament in widget.medicaments) {
      if (!medicament.tookMedicament) {
        took = false;
        break;
      }
    }

    var now = DateTime.now();
    var lastMidnight = DateTime(now.year, now.month, now.day);

    if (widget.date.compareTo(lastMidnight) < 0) {
      return Opacity(
        opacity: 0.9,
        child: Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: took ? Colors.green : Colors.red,
            ),
            child: took
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Transform.rotate(
                    angle: 180,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))),
      );
    }

    return Badge(
      badgeColor: Colors.grey,
      badgeContent: Text(
        widget.medicaments.length.toString(),
        style: const TextStyle().copyWith(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
    );
  }
}
