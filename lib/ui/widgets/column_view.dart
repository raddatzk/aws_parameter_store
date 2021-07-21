import 'package:aws_parameter_store/bloc/context/application_context_cubit.dart';
import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_column.dart';
import 'bucket_column.dart';
import 'parameter_settings.dart';
import 'profile_column.dart';
import 'property_column.dart';

class ColumnView extends StatefulWidget {
  const ColumnView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ColumnViewState();
}

class _ColumnViewState extends State<ColumnView> {
  late final ScrollController controller = ScrollController();

  void scrollController() {
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationContext, ApplicationContextState>(
      bloc: sl<ApplicationContext>(),
      builder: (context, state) {
        if (state is ApplicationContextPrepared) {
          if (controller.hasClients) {
            WidgetsBinding.instance!.addPostFrameCallback((_) => scrollController());
          }
          final columns = <Widget>[
            BucketColumn(state: state),
            const VerticalDivider(),
          ];
          if (state.currentBucket != null) {
            columns.addAll([
              ProfileColumn(state: state),
              const VerticalDivider(),
            ]);
          }
          if (state.currentProfile != null) {
            columns.addAll([
              AppColumn(state: state),
              const VerticalDivider(),
            ]);
          }
          if (state.currentApp != null) {
            columns.addAll([
              PropertyColumn(state: state),
              const VerticalDivider(),
            ]);
          }
          if (state.currentProperty != null) {
            columns.addAll([
              ParameterSettings(state: state),
              const VerticalDivider(),
            ]);
          }

          return Scrollbar(
            child: BlocBuilder<ScrollHandler, ScrollHandlerState>(
              bloc: sl<ScrollHandler>(),
              builder: (context, state) {
                return ListView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: columns,
                    physics: state.scrollOverview ? null : const NeverScrollableScrollPhysics(),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}