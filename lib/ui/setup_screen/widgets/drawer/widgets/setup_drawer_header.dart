import 'package:flutter/material.dart';

import '../../../../../main.dart';

class SetupDrawerHeader extends StatelessWidget {
  const SetupDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("aws_parameter_store", style: TextStyle(fontSize: 20.0)),
        Text("Version: ${packageInfo.version}"),
      ]),
    );
  }
}
