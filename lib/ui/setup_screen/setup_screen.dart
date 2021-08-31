import 'package:aws_parameter_store/ui/setup_screen/widgets/drawer/widgets/show_logs_drawer_item.dart';
import 'package:flutter/material.dart';

import 'widgets/drawer/widgets/setup_drawer_header.dart';
import 'widgets/setup_list/setup_list.dart';
import 'widgets/setup_list/setup_list_widget.dart';
import 'widgets/setup_save_button/save_button.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<SetupListState>();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: const [
            SetupDrawerHeader(),
            ShowLogsDrawerItem(),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("setup"),
      ),
      body: SetupList(key: key),
      floatingActionButton: const SaveButton(),
    );
  }
}
