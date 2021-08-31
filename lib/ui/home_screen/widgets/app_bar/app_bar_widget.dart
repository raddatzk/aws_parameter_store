import 'package:flutter/material.dart';

import '../../../../main.dart';
import 'app_bar_cubit.dart';
import 'widgets/add_button/add_button_widget.dart';
import 'widgets/delete_button.dart';
import 'widgets/save_button.dart';

class AwsAppBar extends StatelessWidget implements PreferredSizeWidget {
  AwsAppBar({Key? key, required this.state}) : super(key: key);

  final AwsAppBarContext appBar = sl<AwsAppBarContext>();
  final AwsAppBarContextState state;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: TextButton(
        child: const Icon(Icons.settings),
        onPressed: () => appBar.onSettingsPressed(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("overview"),
          TextButton(
            onPressed: appBar.onRefreshPressed,
            child: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      actions: _buildActions(state, context),
    );
  }

  List<Widget> _buildActions(AwsAppBarContextState state, BuildContext context) {
    final result = <Widget>[];
    if (state.modified != null) {
      result.addAll([
        if (state.modified!) SaveButton(modified: state.modified!),
        const DeleteButton(),
        if (!state.modified!) const AddButton(),
      ]);
    } else {
      result.add(const AddButton());
    }

    return result;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
