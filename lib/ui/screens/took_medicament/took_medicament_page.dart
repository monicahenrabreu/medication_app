import 'package:flutter/material.dart';

class TookMedicamentPage extends StatefulWidget {
  const TookMedicamentPage(
    this.payload, {
    Key? key,
  }) : super(key: key);

  final String? payload;

  @override
  State<StatefulWidget> createState() => TookMedicamentPageState();
}

class TookMedicamentPageState extends State<TookMedicamentPage> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Did you take the medicament?'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Yes'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context)
                      .primaryColor, // set the background color
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // set the background color
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Snooze'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // set the background color
                ),
              ),
            ],
          ),
        ),
      );
}
