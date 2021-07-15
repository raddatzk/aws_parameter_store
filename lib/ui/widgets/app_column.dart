import 'package:aws_parameter_store/bloc/appbar/appbar_cubit.dart';
import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'column_base.dart';

class AppColumn extends StatelessWidget {
  final ContextPrepared state;

  const AppColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profiles = state.data[state.selectedProfile]!;
    final appKeys = profiles.keys.toList();
    return ColumnBase(
      leadingIcon: Icons.folder,
      width: 200,
      keys: appKeys,
      selectedKey: state.selectedApp,
      callback: (app) {
        sl<OverviewCubit>().refresh(
          selectedProfile: state.selectedProfile,
          selectedApp: app,
        );
        sl<AppBarCubit>().disablePropertyActions();
      },
    );
  }
}
