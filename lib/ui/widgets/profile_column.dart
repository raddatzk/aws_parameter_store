import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/ui/widgets/column_base.dart';
import 'package:flutter/material.dart';

int sortProfiles(String a, String b) {
  if (a == "all profiles") {
    return -1;
  }
  if (b == "all profiles") {
    return 1;
  }
  return a.compareTo(b);
}

class ProfileColumn extends StatelessWidget {
  final ApplicationContextPrepared state;

  const ProfileColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileKeys = state.data[state.bucket]!.keys.toList()..sort(sortProfiles);
    return ColumnBase(
      leadingIcon: Icons.folder,
      width: 200,
      keys: profileKeys,
      selectedKey: state.profile,
      onTap: (profile) {
        sl<ApplicationContext>().goTo(
          state.bucket,
          profile: profile,
        );
      },
    );
  }
}
