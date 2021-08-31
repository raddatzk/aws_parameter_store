import 'package:flutter/material.dart';

import 'widgets/setup_drawer_header.dart';
import 'widgets/show_logs_drawer_item.dart';

class SetupDrawer extends StatelessWidget {
  const SetupDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: const [
          SetupDrawerHeader(),
          ShowLogsDrawerItem(),
        ],
      ),
    );
  }
}
