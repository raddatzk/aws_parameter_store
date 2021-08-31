import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/widgets/add_button/add_button.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/column_base.dart';
import 'package:flutter/material.dart';

import '../column_view.dart';

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
  final ColumnViewPrepared state;

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
        sl<ColumnViewContext>().goTo(
          state.bucket,
          profile: profile,
        );
        sl<AddButtonContext>().set(state.bucket, profile: profile);
      },
    );
  }
}
