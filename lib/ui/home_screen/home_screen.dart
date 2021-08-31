import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import 'widgets/app_bar/app_bar.dart';
import 'widgets/column_view/column_view_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AwsAppBarContext, AwsAppBarContextState>(
      bloc: sl<AwsAppBarContext>(),
      builder: (context, state) {
        return Scaffold(
          appBar: AwsAppBar(
            state: state,
          ),
          body: Stack(children: [
            if (state.loading) const LinearProgressIndicator(),
            const ColumnView(),
          ]),
        );
      },
    );
  }
}
