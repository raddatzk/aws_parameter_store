import 'package:aws_parameter_store/bloc/appbar/appbar_cubit.dart';
import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'column_base.dart';

class PropertyColumn extends StatelessWidget {
  final ContextPrepared state;

  const PropertyColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apps = state.data[state.selectedProfile]!;
    final properties = apps[state.selectedApp]!;
    final propertyKeys = properties.map((e) => e.property).toList();
    return ColumnBase(
      leadingIcon: Icons.insert_drive_file_rounded,
      width: 400,
      keys: propertyKeys,
      selectedKey: state.selectedProperty,
      callback: (property) async {
        sl<OverviewCubit>().refresh(
          selectedProfile: state.selectedProfile,
          selectedApp: state.selectedApp,
          selectedProperty: property,
        );
        final relativeName = properties.firstWhere((element) => element.property == property).relativeName;
        sl<ParameterActions>().reset();
        sl<ParameterActions>().load(relativeName);
        sl<AppBarCubit>().enablePropertyActions();
      },
    );
  }
}
