import 'package:aws_parameter_store/bloc/appbar/appbar_cubit.dart';
import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'widgets/column_view.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final OverviewCubit awsCubit = sl<OverviewCubit>();

  List<Widget> buildActions(AppBarState state, BuildContext context) {
    final result = <Widget>[
      BlocBuilder<OverviewCubit, OverviewState>(
        bloc: sl<OverviewCubit>(),
        builder: (context, state) {
          return TextButton(
            child: const Icon(Icons.add),
            onPressed: state is ContextPrepared
                ? () async {
                    TextEditingController _profile = TextEditingController(text: state.selectedProfile);
                    TextEditingController _app = TextEditingController(text: state.selectedApp);
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
                                  labelText: "profile",
                                ),
                                readOnly: state.selectedProfile != null,
                                controller: _profile,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "app",
                                ),
                                readOnly: state.selectedProfile != null,
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
                      await sl<OverviewCubit>().add(_profile.text, _app.text, _property.text);
                    }
                  }
                : () {},
          );
        },
      ),
    ];
    if (state.showParameterActions) {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarCubit, AppBarState>(
      bloc: sl<AppBarCubit>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("overview"),
                TextButton(
                  onPressed: () => sl<OverviewCubit>().initialize(),
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
}
