import 'package:flutter/material.dart';

class AddParameterDialog extends StatefulWidget {

  final TextEditingController bucket;
  final TextEditingController profile;
  final TextEditingController app;
  final TextEditingController property;

  const AddParameterDialog({Key? key, required this.bucket, required this.profile, required this.app, required this.property}) : super(key: key);

  @override
  State<AddParameterDialog> createState() => _AddParameterDialogState();
}

class _AddParameterDialogState extends State<AddParameterDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("create"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "bucket",
            ),
            readOnly: true,
            controller: widget.bucket,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "profile",
            ),
            readOnly: widget.profile.text != "",
            controller: widget.profile,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "app",
            ),
            readOnly: widget.app.text != "",
            controller: widget.app,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "property",
            ),
            controller: widget.property,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: const Text("save"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
