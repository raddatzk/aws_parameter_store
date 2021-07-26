import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_column.dart';
import 'bucket_column.dart';
import 'discard_changes_dialog.dart';
import 'parameter_column.dart';
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
    return BlocConsumer<ApplicationContext, ApplicationContextState>(
      bloc: sl<ApplicationContext>(),
      buildWhen: (previous, current) => current is ApplicationContextPrepared,
      listener: (context, state) async {
        if (state is DiscardChanges) {
          final result = await showDialog(context: context, builder: (context) => const DiscardChangesDialog());
          if (result) {
            sl<ApplicationContext>().goTo(state.bucket, profile: state.profile, app: state.app, property: state.property, forceAbort: true, lastState: state.lastState);
          }
        }
      },
      builder: (context, state) {
        if (state is ApplicationContextInitial) return Container();
        final _state = (state as ApplicationContextPrepared);
        if (controller.hasClients) {
          WidgetsBinding.instance!.addPostFrameCallback((_) => scrollController());
        }
        final columns = <Widget>[
          BucketColumn(state: _state),
          const VerticalDivider(),
          ProfileColumn(state: _state),
          const VerticalDivider(),
        ];
        if (state.profile != null) {
          columns.addAll([
            AppColumn(state: _state),
            const VerticalDivider(),
          ]);
        }
        if (state.app != null) {
          columns.addAll([
            PropertyColumn(state: _state),
            const VerticalDivider(),
          ]);
        }
        if (state.property != null) {
          columns.addAll([
            ParameterColumn(key: ValueKey<ApplicationContextPrepared>(state), state: _state),
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
      },
    );
  }
}
