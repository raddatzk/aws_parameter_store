import 'package:aws_parameter_store/bloc/context/application_context_cubit.dart';
import 'package:aws_parameter_store/bloc/parameter_actions/parameter_actions.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'column_base.dart';

int sortProperties(String a, String b) => a.compareTo(b);

class PropertyColumn extends StatelessWidget {
  final ApplicationContextPrepared state;

  const PropertyColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profiles = state.data[state.currentBucket]!;
    final apps = profiles[state.currentProfile]!;
    final properties = apps[state.currentApp]!;
    final propertyKeys = properties.map((e) => e.property).toList()..sort(sortProperties);
    return ColumnBase(
      leadingIcon: Icons.insert_drive_file_rounded,
      width: 400,
      keys: propertyKeys,
      selectedKey: state.currentProperty,
      onTap: (property) async {
        sl<ApplicationContext>().reloadCurrentPath(
          state.currentBucket!,
          selectedProfile: state.currentProfile!,
          selectedApp: state.currentApp,
          selectedProperty: property,
        );
        final relativeName = properties.firstWhere((element) => element.property == property).relativeName;
        sl<ParameterActions>().load(relativeName, state.currentBucket!);
      },
    );
  }
}
