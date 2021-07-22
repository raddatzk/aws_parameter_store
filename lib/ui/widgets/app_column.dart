import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'column_base.dart';

int sortApps(String a, String b) {
  if (a == "all applications") {
    return -1;
  }
  if (b == "all applications") {
    return 1;
  }
  return a.compareTo(b);
}

class AppColumn extends StatelessWidget {
  final ApplicationContextPrepared state;

  const AppColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profiles = state.data[state.bucket]![state.profile]!;
    final appKeys = profiles.keys.toList()..sort(sortApps);
    return ColumnBase(
      leadingIcon: Icons.folder,
      width: 200,
      keys: appKeys,
      selectedKey: state.app,
      onTap: (app) {
        sl<ApplicationContext>().goTo(
          state.bucket,
          profile: state.profile!,
          app: app,
        );
      },
    );
  }
}
