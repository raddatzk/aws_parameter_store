import 'package:aws_parameter_store/bloc/app_bar_context/app_bar_context_cubit.dart';
import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'widgets/add_button.dart';
import 'widgets/column_view.dart';
import 'widgets/delete_button.dart';
import 'widgets/save_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarContext, AppBarContextState>(
      bloc: sl<AppBarContext>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: TextButton(
              child: const Icon(Icons.settings),
              onPressed: () => Navigator.pushReplacementNamed(context, "/setup"),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("overview"),
                TextButton(
                  onPressed: () => sl<ApplicationContext>().reloadCurrentBucket(),
                  child: const Icon(
                    Icons.refresh,
                  ),
                ),
              ],
            ),
            actions: buildActions(state, context),
          ),
          body: Stack(children: [
            if (state.loading) const LinearProgressIndicator(),
            const ColumnView(),
          ]),
        );
      },
    );
  }

  List<Widget> buildActions(AppBarContextState state, BuildContext context) {
    final result = <Widget>[];
    if (state is ParameterAvailable) {
      result.addAll([
        SaveButton(state: state),
        DeleteButton(state: state),
        if (!state.modified) AddButton(state: state),
      ]);
    }
    if (state is ParameterNotAvailable) {
      result.add(AddButton(state: state));
    }

    return result;
  }
}
