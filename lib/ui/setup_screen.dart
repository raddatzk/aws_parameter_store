import 'package:aws_parameter_store/bloc/setup_is_valid/setup_is_valid_cubit.dart';
import 'package:aws_parameter_store/bloc/setup_items/setup_items_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/setup_list.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<SetupListState>();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("AWS Parameter Store", style: TextStyle(fontSize: 20.0)),
                Text("Version: ${packageInfo.version}"),
              ]),
            ),
            Card(
              child: ListTile(
                title: const Text("show logs"),
                leading: const Icon(Icons.text_snippet),
                onTap: () async {
                  var logs = await FLog.getAllLogs();
                  var buffer = StringBuffer();

                  if (logs.isNotEmpty) {
                    for (var log in logs) {
                      buffer.write(Formatter.format(log, FLog.getDefaultConfigurations()));
                    }
                  } else {
                    buffer.write("No logs found!");
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("logs"),
                        content: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SelectableText(
                            buffer.toString(),
                            style: const TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("setup"),
      ),
      body: SetupList(key: key),
      floatingActionButton: BlocBuilder<SetupIsValidCubit, SetupIsValidState>(
        bloc: sl<SetupIsValidCubit>(),
        builder: (context, state) {
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: state.allItemsInitialized
                ? () async {
              await sl<SetupItemsCubit>().saveAllAndGoToHome();
              Navigator.pushReplacementNamed(context, "/home");
            }
                : null,
          );
        },
      ),
    );
  }
}
