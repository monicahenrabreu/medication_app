import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextMedicamentFormField extends StatefulWidget {
  final TextEditingController controllerName;

  const TextMedicamentFormField({
    Key? key,
    required this.controllerName,
  }) : super(key: key);

  @override
  State<TextMedicamentFormField> createState() =>
      _TextMedicamentFormFieldState();
}

class _TextMedicamentFormFieldState extends State<TextMedicamentFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controllerName,
        validator: _validateName,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.addMedicamentName,
            labelStyle: const TextStyle(fontSize: 18, color: Colors.grey),
            hintText: AppLocalizations.of(context)!.addMedicamentHint,
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
      return AppLocalizations.of(context)!.addMedicamentNoName;
    }
    return null;
  }
}
