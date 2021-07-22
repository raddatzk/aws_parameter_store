import 'package:aws_parameter_store/bloc/setup_is_valid/setup_is_valid_cubit.dart';
import 'package:aws_parameter_store/bloc/setup_items/setup_items_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/setup_list.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<SetupListState>();

    return Scaffold(
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
                ? () {
                    Navigator.pushReplacementNamed(context, "/home");
                    sl<SetupItemsCubit>().saveAllAndGoToHome();
                  }
                : null,
          );
        },
      ),
    );
  }
}
