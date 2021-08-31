import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/column_view.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/parameter_column/parameter_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../main.dart';
import 'add_button_cubit.dart';
import 'add_parameter_dialog.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddButtonContext, AddButtonState>(
      bloc: sl<AddButtonContext>(),
      builder: (context, state) {
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
              sl<ParameterColumnContext>().createDraft(_bucket.text, _profile.text, _app.text, _property.text);
              sl<ColumnViewContext>().addNewParameterAsDraft(_bucket.text, _profile.text, _app.text, _property.text);
            }
          },
        );
      },
    );
  }
}
