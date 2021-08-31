import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/parameter_column/parameter_column.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key, required this.modified}) : super(key: key);

  final bool modified;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Icon(Icons.save),
      onPressed: modified ? () => sl<ParameterColumnContext>().save() : () {},
    );
  }
}
