import 'package:aws_parameter_store/bloc/app_bar_context/app_bar_context_cubit.dart';
import 'package:aws_parameter_store/bloc/application_context/application_context_cubit.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'add_parameter_dialog.dart';

class AddButton extends StatelessWidget {

  const AddButton({Key? key, required this.state}): super(key: key);

  final AbstractParameter state;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        TextEditingController _bucket = TextEditingController(text: state.bucket);
        TextEditingController _profile = TextEditingController(text: state.profile);
        TextEditingController _app = TextEditingController(text: state.app);
        TextEditingController _property = TextEditingController();
        bool result = await showDialog(
          context: context,
          builder: (context) => AddParameterDialog(
            bucket: _bucket,
            profile: _profile,
            app: _app,
            property: _property,
          ),
        );
        if (result) {
          sl<ApplicationContext>().addNewParameterAsDraft(_bucket.text, _profile.text, _app.text, _property.text);
        }
      },
    );
  }
}
