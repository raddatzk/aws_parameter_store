import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import '../../logs_dialog.dart';

class ShowLogsDrawerItem extends StatelessWidget {
  const ShowLogsDrawerItem({Key? key}) : super(key: key);

  Future<String> formatLogsAsString() async {
    var logs = await FLog.getAllLogs();
    var buffer = StringBuffer();

    if (logs.isNotEmpty) {
      for (var log in logs) {
        buffer.write(Formatter.format(log, FLog.getDefaultConfigurations()));
      }
    } else {
      buffer.write("No logs found!");
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("show logs"),
        leading: const Icon(Icons.text_snippet),
        onTap: () async {
          final logs = await formatLogsAsString();

          showDialog(
            context: context,
            builder: (context) {
              return LogsDialog(logs: logs);
            },
          );
        },
      ),
    );
  }
}
