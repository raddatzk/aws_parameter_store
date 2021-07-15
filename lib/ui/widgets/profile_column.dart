import 'package:aws_parameter_store/bloc/appbar/appbar_cubit.dart';
import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/ui/widgets/column_base.dart';
import 'package:flutter/material.dart';

class ProfileColumn extends StatelessWidget {
  final ContextPrepared state;

  const ProfileColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileKeys = state.data.keys.toList();
    return ColumnBase(
      leadingIcon: Icons.folder,
      width: 200,
      keys: profileKeys,
      selectedKey: state.selectedProfile,
      callback: (profile) {
        sl<OverviewCubit>().refresh(
          selectedProfile: profile,
        );
        sl<AppBarCubit>().disablePropertyActions();
      },
    );
  }
}
