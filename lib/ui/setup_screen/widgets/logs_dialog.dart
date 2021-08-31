import 'package:flutter/material.dart';

class LogsDialog extends StatelessWidget {
  const LogsDialog({Key? key, required this.logs}) : super(key: key);

  final String logs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("logs"),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          logs,
          style: const TextStyle(
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}
