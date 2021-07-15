import 'package:aws_parameter_store/bloc/overview/overview_cubit.dart';
import 'package:aws_parameter_store/ui/widgets/profile_column.dart';
import 'package:aws_parameter_store/ui/widgets/property_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import 'app_column.dart';
import 'parameter_settings.dart';

class ColumnView extends StatefulWidget {
  const ColumnView({Key? key}) : super(key: key);

  @override
  _ColumnViewState createState() => _ColumnViewState();
}

class _ColumnViewState extends State<ColumnView> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      print(controller.position.maxScrollExtent);
    });
  }

  void scrollController() {
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewCubit, OverviewState>(
      bloc: sl<OverviewCubit>(),
      builder: (context, state) {
        if (controller.hasClients) {
          WidgetsBinding.instance!.addPostFrameCallback((_) => scrollController());
        }
        if (state is ContextPrepared) {
          final columns = <Widget>[
            ProfileColumn(state: state),
            const VerticalDivider(),
          ];
          if (state.selectedProfile != null) {
            columns.addAll([
              AppColumn(state: state),
              const VerticalDivider(),
            ]);
          }
          if (state.selectedApp != null) {
            columns.addAll([
              PropertyColumn(state: state),
              const VerticalDivider(),
            ]);
          }
          if (state.selectedProperty != null) {
            columns.addAll([
              const ParameterSettings(),
              const VerticalDivider(),
            ]);
          }

          return Scrollbar(
            controller: controller,
            child: ListView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: columns,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
