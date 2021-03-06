import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../column_view.dart';
import 'column_base.dart';

int sortProperties(String a, String b) => a.compareTo(b);

class PropertyColumn extends StatelessWidget {
  final ColumnViewPrepared state;

  const PropertyColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profiles = state.data[state.bucket]!;
    final apps = profiles[state.profile]!;
    final properties = apps[state.app]!;
    final propertyKeys = properties.map((e) => e.property).toList()..sort(sortProperties);
    return ColumnBase(
      leadingIcon: Icons.insert_drive_file_rounded,
      width: 400,
      keys: propertyKeys,
      selectedKey: state.property,
      onTap: (property) {
        sl<ColumnViewContext>().goTo(
          state.bucket,
          profile: state.profile!,
          app: state.app!,
          property: property,
        );
        sl<AwsAppBarContext>().enterParameter();
      },
    );
  }
}
