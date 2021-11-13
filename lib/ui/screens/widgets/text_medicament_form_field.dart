import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TextMedicamentFormField extends StatelessWidget {
  final TextEditingController _controllerName;

  const TextMedicamentFormField(this._controllerName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _controllerName,
        validator: _validateName,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'Pill name',
            labelStyle: const TextStyle(fontSize: 18, color: Colors.grey),
            hintText: 'ex: Benuron',
            hintStyle: const TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16))));
  }

  String? _validateName(String? text) {
    if (text == null || text.isEmpty) {
      return 'NoName';
    }
    return null;
  }
}
