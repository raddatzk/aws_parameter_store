import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'column_view.dart';
import 'widgets/app_column.dart';
import 'widgets/bucket_column.dart';
import 'widgets/discard_changes_dialog.dart';
import 'widgets/parameter_column/parameter_column.dart';
import 'widgets/parameter_column/parameter_column_widget.dart';
import 'widgets/profile_column.dart';
import 'widgets/property_column.dart';

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
    return BlocConsumer<ColumnViewContext, ColumnViewState>(
      bloc: sl<ColumnViewContext>(),
      buildWhen: (previous, current) => current is ColumnViewPrepared,
      listener: (context, state) async {
        if (state is AskToDiscardChanges) {
          final result = await showDialog(context: context, builder: (context) => const DiscardChangesDialog());
          if (result) {
            sl<ColumnViewContext>().goTo(state.bucket, profile: state.profile, app: state.app, property: state.property, forceAbort: true, lastState: state.lastState);
          }
        }
      },
      builder: (context, state) {
        if (state is ColumnViewInitial) return Container();
        final _state = (state as ColumnViewPrepared);
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
            BlocBuilder<ParameterColumnContext, ParameterColumnState>(
              bloc: sl<ParameterColumnContext>(),
              builder: (context, state) => ParameterColumn(key: ValueKey<ParameterColumnState>(state), state: state),
            ),
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
