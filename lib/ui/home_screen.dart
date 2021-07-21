import 'package:aws_parameter_store/bloc/context/application_context_cubit.dart';
import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'widgets/column_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParameterActions, ParameterActionsState>(
      bloc: sl<ParameterActions>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("overview"),
                TextButton(
                  onPressed: () => sl<ApplicationContext>().initializeCurrentBucket(),
                  child: const Icon(
                    Icons.refresh,
                  ),
                ),
              ],
            ),
            actions: buildActions(state, context),
          ),
          body: const ColumnView(),
        );
      },
    );
  }

  List<Widget> buildActions(ParameterActionsState state, BuildContext context) {
    final result = <Widget>[
      BlocBuilder<ApplicationContext, ApplicationContextState>(
        bloc: sl<ApplicationContext>(),
        builder: (context, state) {
          return TextButton(
            child: const Icon(Icons.add),
            onPressed: state is ApplicationContextPrepared && !state.draft
                ? () async {
              TextEditingController _bucket = TextEditingController(text: state.currentBucket);
              TextEditingController _profile = TextEditingController(text: state.currentProfile);
              TextEditingController _app = TextEditingController(text: state.currentApp);
              TextEditingController _property = TextEditingController();
              bool result = await showDialog(
                context: context,
                builder: (context) {
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
                          controller: _bucket,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "profile",
                          ),
                          readOnly: state.currentProfile != null,
                          controller: _profile,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "app",
                          ),
                          readOnly: state.currentApp != null,
                          controller: _app,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "property",
                          ),
                          controller: _property,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text("cancel"),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text("save"),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
              if (result) {
                sl<ApplicationContext>().addDraft(_profile.text, _app.text, _property.text);
              }
            }
                : () {},
          );
        },
      ),
    ];
    if (state is ParameterLoaded) {
      result.addAll([
        TextButton(
          child: const Icon(Icons.save),
          onPressed: () => sl<ParameterActions>().initiateSave(),
        ),
        TextButton(
          child: const Icon(Icons.delete),
          onPressed: () => sl<ParameterActions>().initiateDelete(),
        )
      ]);
    }
    return result;
  }
}
