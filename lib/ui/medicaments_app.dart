import 'package:flutter/material.dart';
import 'package:medicaments_app/ui/screens/home/home_page.dart';

class MedicamentsApp extends StatelessWidget {
  const MedicamentsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff6fbe53),
      ),
      home: HomePage(),
    );
  }
}
