import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/widgets/add_button/add_button.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../column_view.dart';
import 'column_base.dart';

class BucketColumn extends StatelessWidget {
  final ColumnViewPrepared state;

  const BucketColumn({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buckets = state.data.keys.toList()..sort((a, b) => a.compareTo(b));
    return ColumnBase(
      leadingIcon: Icons.work,
      keys: buckets,
      width: 200,
      selectedKey: state.bucket,
      onTap: (bucket) {
        sl<ColumnViewContext>().goTo(
          bucket,
        );
        sl<AddButtonContext>().set(bucket);
      },
    );
  }
}
