import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicaments_app/medicaments_app.dart';

class AddMedicamentIcon extends StatelessWidget {
  const AddMedicamentIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(routeAdd, arguments: 12),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
