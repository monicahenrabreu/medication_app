import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SaveCancelMedicamentButton extends StatelessWidget {
  void Function() onPressedCancel;
  void Function() onPressedSave;

  SaveCancelMedicamentButton(this.onPressedCancel, this.onPressedSave,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          child: Text('Cancel'),
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 18),
            primary: Theme.of(context).primaryColor,
          ),
          onPressed: onPressedCancel,
        ),
        ElevatedButton(
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 18),
            primary: Theme.of(context).primaryColor,
          ),
          onPressed: onPressedSave,
        ),
      ],
    );
  }
}
