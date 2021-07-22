import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'column_base.dart';

class BucketColumn extends StatelessWidget {
  final ApplicationContextPrepared state;

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
        sl<ApplicationContext>().goTo(
          bucket,
        );
      },
    );
  }
}
