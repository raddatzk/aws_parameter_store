import 'package:flutter/material.dart';

class DiscardChangesDialog extends StatelessWidget {
  const DiscardChangesDialog({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("discard changes?"),
      actions: [
        TextButton(
          child: const Text("yes"),
          onPressed: () => Navigator.pop(context, true),
        ),
        TextButton(
          child: const Text("no"),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
